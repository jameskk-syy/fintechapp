import 'package:xml/xml.dart';
class LoanRepaymentResponse {
  final String statusCode;
  final String message;


  factory LoanRepaymentResponse.fromXml(XmlDocument document) {
    final responseNode = document.findAllElements('vmt:PaybackLoanResult').first;

    final statusCode = responseNode.findElements('c4:BankResponseCode').first.text;
    final message = responseNode.findElements('c4:AdditionalInformation').first.text;
    return LoanRepaymentResponse(
      statusCode: statusCode,
      message: message
    );
  }

  LoanRepaymentResponse({required this.statusCode, required this.message});


}

