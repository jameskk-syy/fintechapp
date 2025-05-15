import 'package:xml/xml.dart';

class MiniStatementEntry {
  final String amount;
  final String date;
  final String description;

  MiniStatementEntry({
    required this.amount,
    required this.date,
    required this.description,
  });
}

class MiniStatementResponse {
  final String statusCode;
  final String message;
  final List<MiniStatementEntry> entries;

  MiniStatementResponse({
    required this.statusCode,
    required this.message,
    required this.entries,
  });

  factory MiniStatementResponse.fromXml(XmlDocument document) {
    final resultNode = document.findAllElements('vmt:SavingsMiniStatementResult').firstOrNull;
    if (resultNode == null) {
      throw FormatException("Missing 'vmt:SavingsMiniStatementResult' element.");
    }

    final statusCode = resultNode.getElement('c4:BankResponseCode')?.text ?? 'UNKNOWN';
    final message = resultNode.getElement('c4:AdditionalInformation')?.text ?? 'No message';
    final formattedStatement = resultNode.getElement('c4:FormattedStatement')?.text ?? '';

    final entries = <MiniStatementEntry>[];

    if (formattedStatement.isNotEmpty) {
      final cleaned = formattedStatement.replaceAll('[', '').replaceAll(']', '').trim();
      final lines = cleaned.split(',');

      for (final line in lines) {
        final parts = line.trim().split(' ');
        if (parts.length >= 3) {
          final amount = parts[0];
          final date = parts[1];
          final description = parts.sublist(2).join(' ');
          entries.add(MiniStatementEntry(
            amount: amount,
            date: date,
            description: description,
          ));
        }
      }
    }

    return MiniStatementResponse(
      statusCode: statusCode,
      message: message,
      entries: entries,
    );
  }
}
