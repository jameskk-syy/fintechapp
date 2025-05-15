import 'package:http/http.dart' as http;
import 'package:saccoapp/core/httpInterceptor/http_interceptor.dart';
import 'package:saccoapp/data/datasources/api_domain.dart';
import 'package:saccoapp/data/responses/apply_loan_response.dart';
import 'package:saccoapp/data/responses/check_limit_response.dart';
import 'package:saccoapp/data/responses/loan_laccount_isting_response.dart';
import 'package:saccoapp/data/responses/loan_mini_statement_response.dart';
import 'package:saccoapp/data/responses/loan_repayment_response.dart';
import 'package:saccoapp/data/responses/loan_saving_repayment.dart';
import 'package:xml/xml.dart';

class LoanRepository {
  static Future<LoanAccountListResponse> getLoanAccounts(
    String phoneNumber,
  ) async {
    try {
      final headers = await HeaderInterceptor.getHeaders();
      headers['Content-Type'] = 'text/xml; charset=utf-8';
      headers['SOAPAction'] =
          'http://vmtcomponentmodel/InterfaceSpecification/Interfaces/C4/VMTtoFSPService/GetAccountBalance';
      String entityId = "0002";
      final soapBody = '''
           <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" 
xmlns:c4="http://VMTComponentModel/InterfaceSpecification/FSPDefined/Messages/C
 4/" 
xmlns:vmt1="http://schemas.datacontract.org/2004/07/VMT.BankingIntegration.FSIC
 4Simulator.Common" 
xmlns:vmt="http://VMTComponentModel/InterfaceSpecification/Interfaces/C4/VMTtoF
 SPService">
    <soapenv:Body>
        <vmt:LoanAccountsList>
            <vmt:request>
                <c4:BankShortCode>$entityId</c4:BankShortCode>
                <c4:FSIIdentityId>
                    <vmt1:MSISDN>$phoneNumber</vmt1:MSISDN>
                    <vmt1:VmtReferenceNumber>202000000000000002</vmt1:VmtReferenceNumber>
                    <vmt1:GroupID/>
                    <vmt1:ShortCode/>
                </c4:FSIIdentityId>
                <c4:MessageId>
                    <vmt1:Id>71GzI88r5HvhI000000E</vmt1:Id>
                    <vmt1:TimeStamp>2019-06-24T14:36:15.421+08:00</vmt1:TimeStamp>
                </c4:MessageId>
                <c4:TransactionId>0</c4:TransactionId>
                <c4:TransactionReceiptNumber>6FO8002920</c4:TransactionReceiptNumber>
                <c4:TransactionTypeName>LoanMiniStatement</c4:TransactionTypeName>
                <c4:FSILinkType>Third-Party FI Link Type</c4:FSILinkType>
                <c4:FIAccountNumber>050911081366874</c4:FIAccountNumber>
                <c4:MaximumNumberOfTransactions>5</c4:MaximumNumberOfTransactions>
            </vmt:request>
        </vmt:LoanAccountsList >
    </soapenv:Body>
</soapenv:Envelope>
      ''';

      final response = await http.post(
        Uri.parse(
          '${ApiConstants.transactionApi}/api/v1/fsi-loan/loan-accounts-list',
        ),
        headers: headers,
        body: soapBody,
      );

      if (response.statusCode == 200) {
        final document = XmlDocument.parse(response.body);

        return LoanAccountListResponse.fromXml(document);
      } else {
        throw Exception('Failed with status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error in SOAP call: $e');
      rethrow;
    }
  }
  static Future<LoanMiniStatementResponse> getLoanAccountMiniStatement(
    String phoneNumber,
    String accountNumber,
  ) async {
    try {
      final headers = await HeaderInterceptor.getHeaders();
      headers['Content-Type'] = 'text/xml; charset=utf-8';
      headers['SOAPAction'] =
          'http://vmtcomponentmodel/InterfaceSpecification/Interfaces/C4/VMTtoFSPService/GetAccountBalance';
      String entityId = "0002";
      final soapBody = '''
              <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"
    xmlns:c4="http://VMTComponentModel/InterfaceSpecification/FSPDefined/Messages/C
    4/"
    xmlns:vmt1="http://schemas.datacontract.org/2004/07/VMT.BankingIntegration.FSIC
    4Simulator.Common"
    xmlns:vmt="http://VMTComponentModel/InterfaceSpecification/Interfaces/C4/VMTtoF
    SPService">
    <soapenv:Body>
    <vmt:LoanMiniStatement>
    <vmt:request>
    <c4:BankShortCode>$entityId</c4:BankShortCode>
    <c4:FSIIdentityId>
    <vmt1:MSISDN>$phoneNumber</vmt1:MSISDN>

    <vmt1:VmtReferenceNumber>$accountNumber</vmt1:VmtReferenceNumber>
    <vmt1:GroupID/>
    <vmt1:ShortCode/>
    </c4:FSIIdentityId>
    <c4:MessageId>
    <vmt1:Id>71GzI88r5HvhI000000E</vmt1:Id>
    <vmt1:TimeStamp>2019-06-24T14:36:15.421+08:00</vmt1:TimeStamp>
    </c4:MessageId>
    <c4:TransactionId>0</c4:TransactionId>

    <c4:TransactionReceiptNumber>6FO8002920</c4:TransactionReceiptNumber>
    <c4:TransactionTypeName>LoanMiniStatement</c4:TransactionTypeName>
    <c4:FSILinkType>Third-Party FI Link Type</c4:FSILinkType>
    <c4:FIAccountNumber>050911081366874</c4:FIAccountNumber>
    <c4:MaximumNumberOfTransactions>5</c4:MaximumNumberOfTransactions>
    </vmt:request>
    </vmt:LoanMiniStatement>
    </soapenv:Body>
    </soapenv:Envelope>
      ''';

      final response = await http.post(
        Uri.parse(
          '${ApiConstants.transactionApi}/api/v1/fsi-loan/loan-mini-statements',
        ),
        headers: headers,
        body: soapBody,
      );

      if (response.statusCode == 200) {
        final document = XmlDocument.parse(response.body);

        return LoanMiniStatementResponse.fromXml(document);
      } else {
        throw Exception('Failed with status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error in SOAP call: $e');
      rethrow;
    }
  }
  static Future<SavingRepaymentResponse> payLoanBack(
    String phoneNumber,
    String accountNumber,
  ) async {
    try {
      final headers = await HeaderInterceptor.getHeaders();
      headers['Content-Type'] = 'text/xml; charset=utf-8';
      headers['SOAPAction'] =
          'http://vmtcomponentmodel/InterfaceSpecification/Interfaces/C4/VMTtoFSPService/GetAccountBalance';
      String entityId = "0002";
      final soapBody = '''
       <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"
      xmlns:c4="http://VMTComponentModel/InterfaceSpecification/FSPDefined/Messages/C
      4/"
      xmlns:vmt1="http://schemas.datacontract.org/2004/07/VMT.BankingIntegration.FSIC
      4Simulator.Common"
      xmlns:vmt="http://VMTComponentModel/InterfaceSpecification/Interfaces/C4/VMTtoF
      SPService">
      <soapenv:Body>
      <vmt:PaybackLoanSaving>
      <vmt:request>
      <c4:BankShortCode>$entityId</c4:BankShortCode>
      <c4:FSIIdentityId>
      <vmt1:MSISDN>$phoneNumber</vmt1:MSISDN>

      <vmt1:VmtReferenceNumber>$accountNumber</vmt1:VmtReferenceNumber>
      <vmt1:GroupID/>
      <vmt1:ShortCode/>
      </c4:FSIIdentityId>
      <c4:MessageId>
      <vmt1:Id>71GzI88r5HvhI0000008</vmt1:Id>
      <vmt1:TimeStamp>2019-06-24T14:18:43.100+08:00</vmt1:TimeStamp>
      </c4:MessageId>
      <c4:TransactionId>0</c4:TransactionId>

      <c4:TransactionReceiptNumber>6FO000291S</c4:TransactionReceiptNumber>
      <c4:TransactionTypeName>PayLoan</c4:TransactionTypeName>
      <c4:FSILinkType>Third-Party FI Link Type</c4:FSILinkType>
      <c4:FIAccountNumber>050911081366874</c4:FIAccountNumber>
      <c4:Amount>14.00</c4:Amount>
      </vmt:request>
      </vmt:PaybackLoanSaving>
      </soapenv:Body>
      </soapenv:Envelope>
      ''';

      final response = await http.post(
        Uri.parse(
          '${ApiConstants.transactionApi}/api/v1/fsi-loan/prepay-loan-savings',
        ),
        headers: headers,
        body: soapBody,
      );

      if (response.statusCode == 200) {
        final document = XmlDocument.parse(response.body);
        print('Error in SOAP call: $document');
        return SavingRepaymentResponse.fromXml(document);
      } else {
        throw Exception('Failed with status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error in SOAP call: $e');
      rethrow;
    }
  }
  static Future<LoanRepaymentResponse> payMobileLoanBack(
    String phoneNumber,
    String accountNumber,
    String amount
  ) async {
    try {
      final headers = await HeaderInterceptor.getHeaders();
      headers['Content-Type'] = 'text/xml; charset=utf-8';
      headers['SOAPAction'] =
          'http://vmtcomponentmodel/InterfaceSpecification/Interfaces/C4/VMTtoFSPService/GetAccountBalance';
      String entityId = "0002";
      final soapBody = '''
       <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"
      xmlns:c4="http://VMTComponentModel/InterfaceSpecification/FSPDefined/Messages/C
      4/"
      xmlns:vmt1="http://schemas.datacontract.org/2004/07/VMT.BankingIntegration.FSIC
      4Simulator.Common"
      xmlns:vmt="http://VMTComponentModel/InterfaceSpecification/Interfaces/C4/VMTtoF
      SPService">
      <soapenv:Body>
      <vmt:PaybackLoan>
      <vmt:request>
      <c4:BankShortCode>$entityId</c4:BankShortCode>
      <c4:FSIIdentityId>
      <vmt1:MSISDN>$phoneNumber</vmt1:MSISDN>

      <vmt1:VmtReferenceNumber>$accountNumber</vmt1:VmtReferenceNumber>
      <vmt1:GroupID/>
      <vmt1:ShortCode/>
      </c4:FSIIdentityId>
      <c4:MessageId>
      <vmt1:Id>71GzI88r5HvhI0000008</vmt1:Id>
      <vmt1:TimeStamp>2019-06-24T14:18:43.100+08:00</vmt1:TimeStamp>
      </c4:MessageId>
      <c4:TransactionId>0</c4:TransactionId>

      <c4:TransactionReceiptNumber>6FO000291S</c4:TransactionReceiptNumber>
      <c4:TransactionTypeName>PayLoan</c4:TransactionTypeName>
      <c4:FSILinkType>Third-Party FI Link Type</c4:FSILinkType>
      <c4:FIAccountNumber>050911081366874</c4:FIAccountNumber>
      <c4:Amount>$amount</c4:Amount>
      </vmt:request>
      </vmt:PaybackLoan>
      </soapenv:Body>
      </soapenv:Envelope>
      ''';

      final response = await http.post(
        Uri.parse(
          '${ApiConstants.transactionApi}/api/v1/fsi-loan/prepay-loan-mobile-money',
        ),
        headers: headers,
        body: soapBody,
      );

      if (response.statusCode == 200) {
        final document = XmlDocument.parse(response.body);

        return LoanRepaymentResponse.fromXml(document);
      } else {
        throw Exception('Failed with status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error in SOAP call: $e');
      rethrow;
    }
  }
  static Future<ApplyLoanResponse> applyLoan(
    String phoneNumber,
    String productName,
    String amount
  ) async {
    try {
      final headers = await HeaderInterceptor.getHeaders();
      headers['Content-Type'] = 'text/xml; charset=utf-8';
      headers['SOAPAction'] =
          'http://vmtcomponentmodel/InterfaceSpecification/Interfaces/C4/VMTtoFSPService/GetAccountBalance';
      String entityId = "0002";
      final soapBody = '''
       <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"
      xmlns:c4="http://VMTComponentModel/InterfaceSpecification/FSPDefined/Messages/C
      4/"
      xmlns:vmt1="http://schemas.datacontract.org/2004/07/VMT.BankingIntegration.FSIC
      4Simulator.Common"
      xmlns:vmt="http://VMTComponentModel/InterfaceSpecification/Interfaces/C4/VMTtoF
      SPService">
      <soapenv:Body>
      <vmt:LoanRequest>
      <vmt:request>
      <c4:BankShortCode>$entityId</c4:BankShortCode>
      <c4:FSIIdentityId>
      <vmt1:MSISDN>$phoneNumber</vmt1:MSISDN>

      <vmt1:VmtReferenceNumber>202000000000000002</vmt1:VmtReferenceNumber>
      <vmt1:GroupID/>
      <vmt1:ShortCode/>
      </c4:FSIIdentityId>
      <c4:MessageId>
      <vmt1:Id>71GzI88r5HvhI0000006</vmt1:Id>
      <vmt1:TimeStamp>2019-06-24T14:02:43.828+08:00</vmt1:TimeStamp>
      </c4:MessageId>
      <c4:TransactionId>0</c4:TransactionId>

      <c4:TransactionReceiptNumber>6FO700291P</c4:TransactionReceiptNumber>
      <c4:TransactionTypeName>RequestLoan</c4:TransactionTypeName>
      <c4:FSILinkType>Third-Party FI Link Type</c4:FSILinkType>
      <c4:Amount>$amount</c4:Amount>
      <c4:SimAppTransId>0</c4:SimAppTransId>
      </vmt:request>
      </vmt:LoanRequest>
      </soapenv:Body>
      </soapenv:Envelope>
      ''';

      final response = await http.post(
        Uri.parse(
          '${ApiConstants.transactionApi}/api/v1/fsi-loan/request-disbursement',
        ),
        headers: headers,
        body: soapBody,
      );

      if (response.statusCode == 200) {
        final document = XmlDocument.parse(response.body);

        return ApplyLoanResponse.fromXml(document);
      } else {
        throw Exception('Failed with status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error in SOAP call: $e');
      rethrow;
    }
  }
  static Future<CheckLimitResponse> checkLoanLimit(
    String phoneNumber,
  ) async {
    try {
      final headers = await HeaderInterceptor.getHeaders();
      headers['Content-Type'] = 'text/xml; charset=utf-8';
      headers['SOAPAction'] =
          'http://vmtcomponentmodel/InterfaceSpecification/Interfaces/C4/VMTtoFSPService/GetAccountBalance';
      String entityId = "0002";
      final soapBody = '''
       <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"
        xmlns:c4="http://VMTComponentModel/InterfaceSpecification/FSPDefined/Messages/C
        4/"
        xmlns:vmt1="http://schemas.datacontract.org/2004/07/VMT.BankingIntegration.FSIC
        4Simulator.Common"
        xmlns:vmt="http://VMTComponentModel/InterfaceSpecification/Interfaces/C4/VMTtoF
        SPService">
        <soapenv:Body>
        <vmt:GetLoanCreditLimit>
        <vmt:request>
        <c4:BankShortCode>$entityId</c4:BankShortCode>
        <c4:FSIIdentityId>
        <vmt1:MSISDN>$phoneNumber</vmt1:MSISDN>

        <vmt1:VmtReferenceNumber>202000000000000002</vmt1:VmtReferenceNumber>
        <vmt1:GroupID/>
        <vmt1:ShortCode/>
        </c4:FSIIdentityId>
        <c4:MessageId>
        <vmt1:Id>71GzI88r5HvhI000000I</vmt1:Id>
        <vmt1:TimeStamp>2019-06-24T14:53:24.799+08:00</vmt1:TimeStamp>
        </c4:MessageId>
        <c4:TransactionId>0</c4:TransactionId>

        <c4:TransactionReceiptNumber>6FO6002928</c4:TransactionReceiptNumber>
        <c4:TransactionTypeName>CheckCreditLimit</c4:TransactionTypeName>
        <c4:FSILinkType>Third-Party FI Link Type</c4:FSILinkType>
        </vmt:request>
        </vmt:GetLoanCreditLimit>
        </soapenv:Body>
        </soapenv:Envelope>
      ''';

      final response = await http.post(
        Uri.parse(
          '${ApiConstants.transactionApi}/api/v1/fsi-loan/get-loan-credit-limit',
        ),
        headers: headers,
        body: soapBody,
      );

      if (response.statusCode == 200) {
        final document = XmlDocument.parse(response.body);

        return CheckLimitResponse.fromXml(document);
      } else {
        throw Exception('Failed with status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error in SOAP call: $e');
      rethrow;
    }
  }
}
