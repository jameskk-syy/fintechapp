import 'package:xml/xml.dart';
class SaveMoneyResponse {
  final String statusCode;


  factory SaveMoneyResponse.fromXml(XmlDocument document) {
    final responseNode = document.findAllElements('vmt:VMTInitiatedSavingsDepositResult').first;

    final statusCode = responseNode.findElements('c4:BankResponseCode').first.text;

    return SaveMoneyResponse(
      statusCode: statusCode,
    );
  }

  SaveMoneyResponse({required this.statusCode});
}

