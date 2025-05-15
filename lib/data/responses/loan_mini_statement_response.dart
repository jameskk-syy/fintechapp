import 'package:xml/xml.dart';

class LoanLoanMiniStatementResponse {
  final String amount;
  final String date;
  final String description;

  LoanLoanMiniStatementResponse({
    required this.amount,
    required this.date,
    required this.description,
  });
}

class LoanMiniStatementResponse {
  final String statusCode;
  final String message;
  final List<LoanLoanMiniStatementResponse> entries;

  LoanMiniStatementResponse({
    required this.statusCode,
    required this.message,
    required this.entries,
  });

  factory LoanMiniStatementResponse.fromXml(XmlDocument document) {
    final resultNode = document.findAllElements('vmt:LoanMiniStatementResult').firstOrNull;
    if (resultNode == null) {
      throw FormatException("Missing 'vmt:LoanMiniStatementResult' element.");
    }

    final statusCode = resultNode.getElement('c4:BankResponseCode')?.text ?? 'UNKNOWN';
    final message = resultNode.getElement('c4:AdditionalInformation')?.text ?? 'No message';
    final formattedStatement = resultNode.getElement('c4:FormattedStatement')?.text ?? '';

    final entries = <LoanLoanMiniStatementResponse>[];

    if (formattedStatement.isNotEmpty) {
      final cleaned = formattedStatement.replaceAll('[', '').replaceAll(']', '').trim();
      final lines = cleaned.split(',');

      for (final line in lines) {
        final parts = line.trim().split(' ');
        if (parts.length >= 3) {
          final amount = parts[0];
          final date = parts[1];
          final description = parts.sublist(2).join(' ');
          entries.add(LoanLoanMiniStatementResponse(
            amount: amount,
            date: date,
            description: description,
          ));
        }
      }
    }

    return  LoanMiniStatementResponse(
      statusCode: statusCode,
      message: message,
      entries: entries,
    );
  }
}
