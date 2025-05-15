import 'package:http/http.dart' as http;
import 'package:saccoapp/data/datasources/api_domain.dart';
import 'package:saccoapp/data/responses/account_balance_response.dart';
import 'package:saccoapp/data/responses/fullstatement.dart';
import 'package:saccoapp/data/responses/saving_min_response.dart';
import 'package:saccoapp/data/responses/productsListResponse.dart';
import 'package:saccoapp/data/responses/save_money_response.dart';
import 'package:saccoapp/data/responses/withdraw_money_response.dart';
import 'package:xml/xml.dart';
import 'package:saccoapp/core/httpInterceptor/http_interceptor.dart';

class TransactionRepository {
  static Future<AccountBalanceResponse> getAccountBalance(
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
xmlns:c4="http://vmtcomponentmodel/InterfaceSpecification/FSPDefined/Messages/C4/"
xmlns:vmt1="http://schemas.datacontract.org/2004/07/VMT.BankingIntegration.FSIC4Simulator.Common"
xmlns:vmt="http://vmtcomponentmodel/InterfaceSpecification/Interfaces/C4/VMTtoFSPService">
  <soapenv:Body>
    <vmt:GetAccountBalance>
      <vmt:request>
        <c4:BankShortCode>0002</c4:BankShortCode>
        <c4:FSIIdentityId>
          <vmt1:MSISDN>$phoneNumber</vmt1:MSISDN>
          <vmt1:VmtReferenceNumber>$phoneNumber</vmt1:VmtReferenceNumber>
          <vmt1:GroupID/>
          <vmt1:ShortCode/>
        </c4:FSIIdentityId>
        <c4:MessageId>
          <vmt1:Id>71GzI88r5HvhI000000G</vmt1:Id>
          <vmt1:TimeStamp>${DateTime.now().toIso8601String()}</vmt1:TimeStamp>
        </c4:MessageId>
        <c4:TransactionId>0</c4:TransactionId>
        <c4:TransactionReceiptNumber>6FO4002926</c4:TransactionReceiptNumber>
        <c4:TransactionTypeName>GetAccountBalance</c4:TransactionTypeName>
        <c4:FSILinkType>Third-Party FI Link Type</c4:FSILinkType>
        <c4:FIAccountNumber>$entityId</c4:FIAccountNumber>
      </vmt:request>
    </vmt:GetAccountBalance>
  </soapenv:Body>
</soapenv:Envelope>
''';

      final response = await http.post(
        Uri.parse('${ApiConstants.transactionApi}/api/v1/account/balance'),
        headers: headers,
        body: soapBody,
      );

      if (response.statusCode == 200) {
        final document = XmlDocument.parse(response.body);

        return AccountBalanceResponse.fromXml(document);
      } else {
        throw Exception('Failed with status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error in SOAP call: $e');
      rethrow;
    }
  }

  static Future<ProductsListResponse> getProductsList(
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
              <vmt:ProductsList >
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
                          <vmt1:TimeStamp>${DateTime.now().toIso8601String()}</vmt1:TimeStamp>
                      </c4:MessageId>
                      <c4:TransactionId>0</c4:TransactionId>
                      <c4:TransactionReceiptNumber>6FO8002920</c4:TransactionReceiptNumber>
                      <c4:TransactionTypeName>LoanMiniStatement</c4:TransactionTypeName>
                      <c4:FSILinkType>Third-Party FI Link Type</c4:FSILinkType>
                      <c4:FIAccountNumber>050911081366874</c4:FIAccountNumber>
                      <c4:MaximumNumberOfTransactions>5</c4:MaximumNumberOfTransactions>
                  </vmt:request>
              </vmt:ProductsList>
          </soapenv:Body>
      </soapenv:Envelope>
''';
      final response = await http.post(
        Uri.parse(
          '${ApiConstants.transactionApi}/api/v1/fsi-loan/loan-products-list',
        ),
        headers: headers,
        body: soapBody,
      );

      if (response.statusCode == 200) {
        final document = XmlDocument.parse(response.body);
        return ProductsListResponse.fromXml(document);
      } else {
        throw Exception('Failed with status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error in SOAP call: $e');
      rethrow;
    }
  }

  static Future<SaveMoneyResponse> saveMoney(
   {required phoneNumber, required amount}
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
      <vmt:VMTInitiatedSavingsDeposit>
      <vmt:request>
      <c4:BankShortCode>$entityId</c4:BankShortCode>
      <c4:FSIIdentityId>
      <vmt1:MSISDN>$phoneNumber</vmt1:MSISDN>

      <vmt1:VmtReferenceNumber>202000000000000002</vmt1:VmtReferenceNumber>
      <vmt1:GroupID/>
      <vmt1:ShortCode/>
      </c4:FSIIdentityId>
      <c4:MessageId>
      <vmt1:Id>71GzI88r5HvhI0000003</vmt1:Id>
      <vmt1:TimeStamp>2019-06-24T13:55:01.202+08:00</vmt1:TimeStamp>
      </c4:MessageId>
      <c4:TransactionId>0</c4:TransactionId>

      <c4:TransactionReceiptNumber>6FO300291L</c4:TransactionReceiptNumber>
      <c4:TransactionTypeName>SavingsDeposit</c4:TransactionTypeName>
      <c4:FSILinkType>Third-Party FI Link Type</c4:FSILinkType>
      <c4:FIAccountNumber>050911081366874</c4:FIAccountNumber>
      <c4:Amount>$amount</c4:Amount>
      </vmt:request>
      </vmt:VMTInitiatedSavingsDeposit>
      </soapenv:Body>
      </soapenv:Envelope>
       ''';
      final response = await http.post(
        Uri.parse(
          '${ApiConstants.transactionApi}/api/v1/transactions/saving-deposit',
        ),
        headers: headers,
        body: soapBody,
      );

      if (response.statusCode == 200) {
        final document = XmlDocument.parse(response.body);
        return SaveMoneyResponse.fromXml(document);
      } else {
        throw Exception('Failed with status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error in SOAP call: $e');
      rethrow;
    }
  }
    static Future<WithdrawMoneyResponse> withdrawMoney(
   {required phoneNumber, required amount}
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
        <vmt:VMTInitiatedSavingsWithdrawal>
        <vmt:request>
        <c4:BankShortCode>$entityId</c4:BankShortCode>
        <c4:FSIIdentityId>
        <vmt1:MSISDN>$phoneNumber</vmt1:MSISDN>
            <vmt1:VmtReferenceNumber>202000000000000002</vmt1:VmtReferenceNumber>
            <vmt1:GroupID/>
            <vmt1:ShortCode/>
            </c4:FSIIdentityId>
            <c4:MessageId>
            <vmt1:Id>71GzI88r5HvhI0000005</vmt1:Id>
            <vmt1:TimeStamp>2019-06-24T13:59:06.820+08:00</vmt1:TimeStamp>
            </c4:MessageId>
            <c4:TransactionId>0</c4:TransactionId>

            <c4:TransactionReceiptNumber>6FO500291N</c4:TransactionReceiptNumber>
            <c4:TransactionTypeName>SavingsWithdrawal</c4:TransactionTypeName>
            <c4:FSILinkType>Third-Party FI Link Type</c4:FSILinkType>
            <c4:FIAccountNumber>050911081366874</c4:FIAccountNumber>
            <c4:Amount>80</c4:Amount>
            </vmt:request>
            </vmt:VMTInitiatedSavingsWithdrawal>
            </soapenv:Body>
            </soapenv:Envelope>
       ''';
      final response = await http.post(
        Uri.parse(
          '${ApiConstants.transactionApi}/api/v1/transactions/saving-withdrawal',
        ),
        headers: headers,
        body: soapBody,
      );
      if (response.statusCode == 200) {
        final document = XmlDocument.parse(response.body);
        return WithdrawMoneyResponse.fromXml(document);
      } else {
        throw Exception('Failed with status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error in SOAP call: $e');
      rethrow;
    }
  }
  static Future<MiniStatementResponse> getSavingsMiniStatement(
   {required phoneNumber}
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
      <vmt:SavingsMiniStatement>
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
      </vmt:SavingsMiniStatement>
      </soapenv:Body>
      </soapenv:Envelope>
       ''';
      final response = await http.post(
        Uri.parse(
          '${ApiConstants.transactionApi}/api/v1/fsi-loan/savings-mini-statements',
        ),
        headers: headers,
        body: soapBody,
      );
      if (response.statusCode == 200) {
        final document = XmlDocument.parse(response.body);
        return MiniStatementResponse.fromXml(document);
      } else {
        throw Exception('Failed with status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error in SOAP call: $e');
      rethrow;
    }
  }
  static Future<FullSavingStatementResponse> getFullStatement(
   {required phoneNumber}
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
                <vmt:SavingsFullStatement>
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
                </vmt:SavingsFullStatement>
                </soapenv:Body>
                </soapenv:Envelope>

       ''';
      final response = await http.post(
        Uri.parse(
          '${ApiConstants.transactionApi}/api/v1/fsi-loan/savings-full-statements',
        ),
        headers: headers,
        body: soapBody,
      );
      if (response.statusCode == 200) {
        final document = XmlDocument.parse(response.body);
        return FullSavingStatementResponse.fromXml(document);
      } else {
        throw Exception('Failed with status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error in SOAP call: $e');
      rethrow;
    }
  }
  
}
