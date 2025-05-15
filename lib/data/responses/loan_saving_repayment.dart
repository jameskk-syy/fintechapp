import 'package:xml/xml.dart';
class SavingRepaymentResponse {
  final String statusCode;
  final String message;


  factory SavingRepaymentResponse.fromXml(XmlDocument document) {
    final responseNode = document.findAllElements('vmt:PaybackLoanSavingResult').first;

    final statusCode = responseNode.findElements('c4:BankResponseCode').first.text;
    final message = responseNode.findElements('c4:AdditionalInformation').first.text;

    return SavingRepaymentResponse(
      statusCode: statusCode,
      message:message
    );
  }

  SavingRepaymentResponse({required this.statusCode, required this.message});

}

