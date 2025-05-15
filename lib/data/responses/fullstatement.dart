import 'package:xml/xml.dart';
class FullSavingStatementResponse {
  final String statusCode;


  factory FullSavingStatementResponse.fromXml(XmlDocument document) {
    final responseNode = document.findAllElements('vmt:SavingsFullStatementResult').first;

    final statusCode = responseNode.findElements('c4:BankResponseCode').first.text;

    return FullSavingStatementResponse(
      statusCode: statusCode,
    );
  }

  FullSavingStatementResponse({required this.statusCode});
}

