import 'package:flutter/material.dart';
import 'package:synpitarn/data/custom_style.dart';
import 'package:synpitarn/data/json_data/common.dart';

class TermConditionEnglish {
  static List<ContentBlock> allContent = [
    ContentBlock.text([
      Data(
          text:
              'The following terms and conditions will be legally effective when the loan has been approved, and the Borrower has received, the loan. It will form an integral part of the Loan Agreement to which it will be appended',
          style: TextStyle(
              decoration: TextDecoration.underline,
              fontWeight: FontWeight.bold,
              fontStyle: FontStyle.italic))
    ]),
    ContentBlock.text([
      Data(
          text:
              'I, whose name and signature appear in this agreement, (hereinafter "'),
      Data(text: 'the Customer', style: CustomStyle.bodyBold()),
      Data(text: '" or "'),
      Data(text: 'the Borrower', style: CustomStyle.bodyBold()),
      Data(
          text:
              '") covenants to Syn Pitarn Co., Ltd. (hereinafter will be referred to as "'),
      Data(text: 'the Company', style: CustomStyle.bodyBold()),
      Data(
          text:
              '") that the Borrower agrees to comply with the terms and conditions as follows.'),
    ]),
    ContentBlock.text([
      Data(
          text:
              '1. According to the terms and conditions of the general loan agreement of the company, I hereby agree that the general loan agreement (hereinafter referred to as "'),
      Data(text: 'loan agreement', style: CustomStyle.bodyBold()),
      Data(
          text:
              '") will be effective when the company has approved the loan request of the Customer in the loan application form (hereinafter referred to as "'),
      Data(text: 'the loan application', style: CustomStyle.bodyBold()),
      Data(text: '") of the loan agreement.'),
    ]),
    ContentBlock.text([
      Data(
          text:
              '2. When the company has considered and approved the loan request of the Customer, the Company will notify the Customer of the loan amount through electronic means or by any other method specified by the company.'),
    ]),
    ContentBlock.text([
      Data(
          text:
              '3. After fully repaying the current loan amount, the Customer can request a new loan through the company’s electronic application ("'),
      Data(text: 'The App', style: CustomStyle.bodyBold()),
      Data(
          text:
              '") or through any channel, and according to the terms and conditions, specified by the Company.'),
    ]),
    ContentBlock.text([
      Data(
          text:
              '4. The company may terminate all or part of the loan without notifying the Customer in advance if the Customer does not follow the terms and conditions in the loan application and/or loan agreement or when the company deems it necessary to protect its rights and benefits from a deterioration in the Customer’s credit worthiness.'),
    ]),
    ContentBlock.text([
      Data(
          text:
              '5. The Customer agrees to repay the principal, interests, fees and any other expense that must be paid to the Company according to the terms and conditions specified in the loan agreement. The Customer must repay not less than the minimum amount specified in the loan application / loan agreement according to the payment dates that the company and Customers agreed together by paying via a bank’s ATM or electronic channel or counter service, or by direct debit, payment points of business partners of the Company, or at the company’s branches or service points, or any other method specified by the company.'),
    ]),
    ContentBlock.text([
      Data(
          text:
              'The Customer agrees to pay the fees and expenses charged by third party agents when in repaying the loan as specified by the Company according to the relevant law and regulation such as when repaying at a bank counter, ATM, electronic channels, payment service points of business partners of the company or by direct debit (hereinafter referred to as "'),
      Data(text: 'third party agent', style: CustomStyle.bodyBold()),
      Data(text: '").'),
    ]),
    ContentBlock.text([
      Data(
          text:
              'The Customer agrees to make repayments within business hours or service hours of the company or the relevant the third-party agent accepting the payment.'),
    ]),
    ContentBlock.text([
      Data(
          text:
              '6. The Company will use the repayment received from the Customer to reduce the debt in the following sequence.'),
    ]),
    ContentBlock.text(paddingLeft: 10, [
      Data(
          text:
              '(a) first, expense and various fees such as debt collection expenses.'),
    ]),
    ContentBlock.text(paddingLeft: 10, [
      Data(text: '(b) next, Default interest'),
    ]),
    ContentBlock.text(paddingLeft: 10, [
      Data(text: '(c) next, Interest and'),
    ]),
    ContentBlock.text(paddingLeft: 10, [
      Data(text: '(d) lastly, Principal'),
    ]),
    ContentBlock.text([
      Data(
          text:
              '7. The Customer can request to repay the entire or part of the outstanding principal before the due date and agrees to repay at the same time all expenses, collection fee, and interest accruing up to the date that the Customer makes such repayment of the principal.'),
    ]),
    ContentBlock.text([
      Data(
          text:
              '8. The Customer agrees to repay interest, fees, penalty fees and other expenses that the Company has reasonably incurred. The Company will disclose the details of such items at the Company’s branch and/or in the official website of the Company which will not be higher than the rate specified by the law.'),
    ]),
    ContentBlock.text([
      Data(
          text:
              'The expenses which are the responsibility of the Customer as the Borrower is as follows (the rate or amount will be as in the announcements above).'),
    ]),
    ContentBlock.text(paddingLeft: 10, [
      Data(text: '(a) Interest'),
    ]),
    ContentBlock.text(paddingLeft: 10, [
      Data(text: ''),
    ]),
    ContentBlock.text(paddingLeft: 10, [
      Data(text: '(c) Collection expenses in following up late debt repayment'),
    ]),
    ContentBlock.text([
      Data(
          text:
              '9. If any of the following events occur, the Company can request the Customer to immediately repay all outstanding principal, interest and fees in full according to the loan application and/or loan agreement to the company.'),
    ]),
    ContentBlock.text(paddingLeft: 10, [
      Data(
          text:
              '(a) The Customer has been judged by a court of law to be incompetent, the court has sequestered the Customer’s property or the court has an order for the Customer’s property to be under the supervision of a receiver.'),
    ]),
    ContentBlock.text(paddingLeft: 10, [
      Data(text: '(b) if the Customer passes away'),
    ]),
    ContentBlock.text(paddingLeft: 10, [
      Data(
          text:
              '(c) When the Customer’s asset is frozen in a legal case, or the property is seized or confiscated or allowed to be seized or confiscated according to the law or legal judgement.'),
    ]),
    ContentBlock.text(paddingLeft: 10, [
      Data(
          text:
              '(d) When the Customer has no domicile or work address in the province that the Company is located.'),
    ]),
    ContentBlock.text([
      Data(
          text:
              '10. The following events are deemed to be a breach of the loan agreement by the Customer which the company will give a written notice of such breach to the Customer so that the Customer can resolve that breach within a suitable period of time.'),
    ]),
    ContentBlock.text(paddingLeft: 10, [
      Data(
          text:
              '(a) When the Customer does not follow the terms and conditions in the loan agreement.'),
    ]),
    ContentBlock.text(paddingLeft: 10, [
      Data(
          text:
              '(b) When the Customer gives false information or give any document that is false or forged to the com(c)y.'),
    ]),
    ContentBlock.text(paddingLeft: 10, [
      Data(
          text:
              '(c) When the Customer does not repay all, or some part, of any installment of the loan according to the agreed loan repayment schedule.'),
    ]),
    ContentBlock.text([
      Data(
          text:
              'If the Customer cannot resolve the agreement breach within a reasonable period of time specified by the company, the Customer agrees to repay all outstanding amounts that the Customer owes according to the loan application and/or loan agreement to the Company immediately.'),
    ]),
    ContentBlock.text([
      Data(
          text:
              '11. the Company will send documents and/or notices to the address that the Customer specified in the loan application/loan agreement. It is deemed that if the Company has performed such action, it has lawfully delivered such documents and/or notices to the Customer and it is deemed that the Customer has acknowledged receipt of such documents and/or such notices.'),
    ]),
    ContentBlock.text([
      Data(
          text:
              'If the Customer changes the address from that specified in the loan application and/or agreement loan, the Customer agrees always to notify the new address to the Company within 7 days from the day of the change according to the method specified by the Company.'),
    ]),
    ContentBlock.text([
      Data(
          text:
              'If the documents and/or notices that the Company sends to the Customer do not reach the Customer or reaches the Customer with delay because the Customer did not notify the change of address, it is deemed that the delivery of the documents and/or notices have legally reached the Customer at the time that the documents and/or notices should have reached the last address that the Customer has notified the Company regardless of the fact that the documents and/or notices will reach the Customers or any other recipient or not.'),
    ]),
    ContentBlock.text([
      Data(
          text:
              'In case the personal data of the Customer is disclosed to a third party for the reason that the Customer did not notify the change of the address to the company, the Customer agrees that the company is not responsible for anything to the Customer whatsoever.'),
    ]),
    ContentBlock.text([
      Data(
          text:
              '12. The Customers agrees to allow the company to disclose, send and receive data on the Customer which the Customer has disclosed or provided to the company, to any corporate body that collects and analyzes credit data (hereinafter will be referred to as "'),
      Data(text: 'credit bureau company', style: CustomStyle.bodyBold()),
      Data(
          text:
              '") including members or service providers of such credit bureau company. This includes data that has been disclosed directly to the company and / or is the customer’s data that the credit bureau Company has received from its members or other service users, for the benefit of analyzing the credit, loan terms and credit amount approval, loan review purposes, loan agreement renewal, risk management and prevention according to the Bank of Thailand’s regulations governing credit bureau business or for the objectives set out in the law and the credit bureau company will send to members and service users. The consent above includes the Customer consenting to the company using the Customer’s data which has been received from the credit bureau company but excludes data that can identify the Customer such as name, surname, ID Number to be used as a factor in building credit models. The Company may assign a third party to perform such modelling work according to the law governing credit bureau business which the Customer has signed to give the consent in a separate document.'),
    ]),
    ContentBlock.text([
      Data(
          text:
              'Moreover, the company might use the data of the Customer to offer other services /products that the Company deems beneficial to the Customer after receiving a separate and clear consent from the Customer. The Customer agrees not to request any damages or compensation from the company resulting from the operation described above.'),
    ]),
    ContentBlock.text([
      Data(
          text:
              '13. The company may change the rate of interest, penalty fee, service fee, other fees and/or various expenses including changing the loan repayment methodology and calculation which is specified in the loan application and/or loan agreement to a rate and / or methodology that the company sees fit subject to the terms new terms being compliant with the relevant law and regulation.'),
    ]),
    ContentBlock.text([
      Data(
          text:
              'Such amendment to the terms and methodology is considered part of the loan application and/or loan agreement.'),
    ]),
    ContentBlock.text([
      Data(
          text:
              'The company will give notice to Customers and announce the details of the changes in the Company’s website for not less than 30 days before the change is effective. However, in case of emergency, the company will notify the change by announcing in a daily Thai newspaper for not less than 7 days in advance and will send the notice to the Customer.'),
    ]),
    ContentBlock.text([
      Data(
          text:
              'In case of changes pursuant to clause 8, the Customer agrees to such changes when the company has given prior notice in writing of not less than 30 days before the change is effective or any other period as specified by the law.'),
    ]),
    ContentBlock.text([
      Data(
          text:
              'The company will also announce such change at every office of the Company and in the Company’s website to let the customer know in advance for not less than 30 days or any period that the law specifies before such change is effective.'),
    ]),
    ContentBlock.text([
      Data(
          text:
              '14. In cases where the company grants a loan rescheduling or any modification to the terms of the loan application and/or loan agreement, the customer will not consider that action as a waiver of any of the rights of the company in the loan application and/or loan agreement.'),
    ]),
    ContentBlock.text([
      Data(
          text:
              '15. The Loan request, loan application, loan agreement, data disclosure consent letter that the customer has signed, notices of interest rate, penalty fee, service fee, other fees and expenses that the company may announce or amend in the future are considered part of the making and receiving of the loan according to the loan application and loan agreement.'),
    ]),
    ContentBlock.text([
      Data(
          text:
              'In case any clause or any part of such document is void, legally invalid, illegal, incomplete or unenforceable according to the law, other parts of such document will remain effective and can be enforced and not affected by such voidness, invalidity, unenforceability of such content.'),
    ]),
    ContentBlock.text([
      Data(
          text:
              'All documents are governed by, and interpreted under, the laws of Thailand.'),
    ]),
    ContentBlock.text([
      Data(
          text:
              '16. The company will collect all personal data (a) provided by the customer or (b) is already available to the company or (c) received from other parties through channels provided or agreed by the customer for the company to use according to the notified objectives only.'),
    ]),
    ContentBlock.text([
      Data(
          text:
              '17. The company will use the personal data of the customer for the following purposess'),
    ]),
    ContentBlock.text(paddingLeft: 10, [
      Data(
          text:
              '(1) the evaluation of the loan application and for the provision of other services'),
    ]),
    ContentBlock.text(paddingLeft: 10, [
      Data(
          text:
              '(2) in identity verification according to the anti-money laundering act or to verify the customer’s qualification for using other products or financial services.'),
    ]),
    ContentBlock.text(paddingLeft: 10, [
      Data(
          text:
              '(3) for use in the provision of on-going transaction management services such as managing loan transaction payment schedule etc.'),
    ]),
    ContentBlock.text(paddingLeft: 10, [
      Data(
          text:
              '(4) To send the information to a third party within relevant scope such as sending personal data to the national credit bureau etc.'),
    ]),
    ContentBlock.text(paddingLeft: 10, [
      Data(
          text:
              '(5) To effectively carry out any work, in whole or in part, relating to the management of personal data, that the company has been requested by other parties.'),
    ]),
    ContentBlock.text(paddingLeft: 10, [
      Data(
          text:
              '(6) To use the rights or to perform the duty according to the agreement made with the customer or the law etc.'),
    ]),
    ContentBlock.text(paddingLeft: 10, [
      Data(
          text:
              '(7) To be used in cancelling a transaction or in its management thereafter'),
    ]),
    ContentBlock.text(paddingLeft: 10, [
      Data(
          text:
              '(8) To process a transaction with the customer appropriately and effectively.'),
    ]),
    ContentBlock.text(paddingLeft: 10, [
      Data(
          text:
              '(9) To be used in other transactions such as the sale and transfer of debt, using the debt as collateral and to perform debt securitization.'),
    ]),
    ContentBlock.text(paddingLeft: 10, [
      Data(
          text:
              '(10) To develop marketing strategy, marketing activity and/or marketing promotion.'),
    ]),
    ContentBlock.text([
      Data(
          text:
              '18. The company may transfer all or some rights and claims that it has in the loan application and/or loan agreement to a third party and may disclose personal data of the customer to a third party as necessary. In such case, the company will notify the customer in writing not less than one loan or interest repayment period before the day that the transfer of such rights become effective.'),
    ]),
    ContentBlock.text([
      Data(
          text:
              '19. The company may assign a legally permitted third-party organization to act on its behalf pursuant to the terms and/or conditions in the loan application and/or loan agreement. The company can disclose data of the customer to such third-party organization as necessary within the objective of the loan application and/or loan agreement as follows.'),
    ]),
    ContentBlock.text(paddingLeft: 10, [
      Data(text: '(a) For loan application, lending and debt collection'),
    ]),
    ContentBlock.text(paddingLeft: 10, [
      Data(text: '(b) For printing and delivering documents to the customer'),
    ]),
    ContentBlock.text(paddingLeft: 10, [
      Data(
          text:
              '(c) For transportation, storing and destroying of customer documents'),
    ]),
    ContentBlock.text(paddingLeft: 10, [
      Data(
          text:
              '(d) For developing, using and maintaining the customer data management system'),
    ]),
    ContentBlock.text([
      Data(
          text:
              'Such outside organizations may include parties in a foreign country which may not have the same level of the personal data protection law as Thailand.'),
    ]),
    ContentBlock.text([
      Data(
          text:
              '20. The company may request a copy of the customer’s house registration from a government agency when the company considers it necessary for the collection of debt. Other parties, companies or any agencies assigned by the company may contact the reference person given in the loan application and/or /loan agreement in cases where the company deems it necessary in the process of making debt collection. The customer agrees to let such parties, companies or any agencies assigned by the company disclose relevant and necessary details in the loan application/loan agreement and debt information to such reference person as necessary to achieve such objective.'),
    ]),
    ContentBlock.text([
      Data(
          text:
              '21. The customer may request the company to disclose, revise, add, delete or revoke the customer’s personal data pursuant to the law and the procedure specified by the company. The company may deny such requests in the following cases and under the relevant law.'),
    ]),
    ContentBlock.text(paddingLeft: 10, [
      Data(
          text:
              '(1) In cases where the customer cannot show clearly that the customer is the owner of the data or has the power to make such request.'),
    ]),
    ContentBlock.text(paddingLeft: 10, [
      Data(
          text:
              '(2) Such request is not reasonable, such as the customer has no right to access such personal data or such personal data are not at the company.'),
    ]),
    ContentBlock.text(paddingLeft: 10, [
      Data(
          text:
              '(3) Such requests are redundant or wasteful such as requests for similar content without reasonable cause etc.'),
    ]),
    ContentBlock.text(paddingLeft: 10, [
      Data(
          text:
              '(4) The company cannot allow customer access to the data, or to make copy or to disclose acquisition of personal data if this does not comply with the law or court order and the performance of that request might cause damage to the right and freedom of other parties. For example, disclosure of those data is also disclosure of personal data of a third party or disclosure or intellectual property or trade secret of a third party.'),
    ]),
    ContentBlock.text(paddingLeft: 10, [
      Data(
          text:
              '(5) In case of complying with the law or in case of defending the legal rights.'),
    ]),
    ContentBlock.text([
      Data(
          text:
              '22. The channel for contacting the company’s personal data protection officer (DPO) is as follows.'),
    ]),
    ContentBlock.text(paddingLeft: 10, [
      Data(text: 'Duangrat Wattapongchat'),
    ]),
    ContentBlock.text(paddingLeft: 10, [
      Data(
          text: 'Tel. +6681-822-5285',
          phoneNumber: '+66818225285',
          style: CustomStyle.linkStyle()),
    ]),
    ContentBlock.text([
      Data(
          text:
              '23. These terms and conditions form is a part of the loan application and/or loan agreement when the loan has been approved by the company and the customer as the borrower has received the loan.'),
    ]),
    ContentBlock.text([
      Data(
          text:
              'The customer has read and understood the details, terms and conditions of this document thoroughly and agrees that it is consistent with the intention and the wish of the customer as the borrower in every respect.'),
    ]),
    ContentBlock.text([
      Data(
          text: 'Personal Data Protection Policy',
          style: CustomStyle.bodyBold()),
    ]),
    ContentBlock.text([
      Data(
          text:
              'This personal data protection policy specifies the details concerning collecting, storing, disclosing personal data of the customer and the concerned right of the customer and how to manage other personal data which are disclosed to the public with the objective to notify such topics.'),
    ]),
    ContentBlock.text([
      Data(text: '1. Definition of personal data'),
    ]),
    ContentBlock.text([
      Data(
          text:
              'Personal data means data concerning a person which can identify that person directly or indirectly but not including specific data of the deceased.'),
    ]),
    ContentBlock.text([
      Data(text: '2. Personal data collected by the company'),
    ]),
    ContentBlock.text([
      Data(text: 'The company will collect the personal data as follows.'),
    ]),
    ContentBlock.text(paddingLeft: 10, [
      Data(
          text:
              'a. Identifiable data filled out into the application form such as name-surname, age, date of birth, ID Number, address, telephone number, contact data, financial data etc.'),
    ]),
    ContentBlock.text(paddingLeft: 10, [
      Data(
          text:
              'b. Identifiable data from directly meeting with the customer such as name-surname, date of birth, ID Number, address, telephone number, contact data etc.'),
    ]),
    ContentBlock.text(paddingLeft: 10, [
      Data(
          text:
              'c. Personal data from indirectly meeting with the customer (including the data received from telephone) such as name-surname, date of birth, ID Number, address, telephone number, contact data, conversation file etc.'),
    ]),
    ContentBlock.text(paddingLeft: 10, [
      Data(
          text:
              'd. Personal data receive in writing or electronic means such as name-surname, date of birth, ID Number, address, telephone number, contact data etc.'),
    ]),
    ContentBlock.text(paddingLeft: 10, [
      Data(
          text:
              'e. IP Address and cookies from accessing website and/or application of the company (please see the policy on cookie in No 9-12).'),
    ]),
    ContentBlock.text([
      Data(text: '3. How to collect and the source of personal data'),
    ]),
    ContentBlock.text([
      Data(
          text:
              'The company has a method of collecting personal data as follows.'),
    ]),
    ContentBlock.text(paddingLeft: 10, [
      Data(text: 'a. Direct collecting of data from the customer'),
    ]),
    ContentBlock.text(paddingLeft: 20, [
      Data(
          text:
              '(1) Application form that is from applying personal loan with the company and the data that the company received from telephone inquiry.'),
    ]),
    ContentBlock.text(paddingLeft: 20, [
      Data(
          text:
              '(2) Document that the company received from submitting the request and various types of form with the company.'),
    ]),
    ContentBlock.text(paddingLeft: 20, [
      Data(
          text:
              '(3) The data received from inquiry about the service and received during service provision to the customer when the customer is at the service point, when meeting with the customer and by telephone contact, electronic means or other communication channels.'),
    ]),
    ContentBlock.text(paddingLeft: 20, [
      Data(
          text:
              '(4) The filled-out data for applying PICO FINANCE loan via the website and/or application of the company.'),
    ]),
    ContentBlock.text(paddingLeft: 20, [
      Data(
          text:
              '(5) The data for using the website and/or application of the company which is from accessing the website and/or application of the company.'),
    ]),
    ContentBlock.text(paddingLeft: 10, [
      Data(text: 'b. Collecting data from a third party'),
    ]),
    ContentBlock.text(paddingLeft: 20, [
      Data(text: '(1) The bank of Thailand'),
    ]),
    ContentBlock.text(paddingLeft: 20, [
      Data(text: '(2) National Credit Bureau'),
    ]),
    ContentBlock.text(paddingLeft: 20, [
      Data(text: '(3) The office of anti-money laundering'),
    ]),
    ContentBlock.text(paddingLeft: 20, [
      Data(text: '(4) Ministry of Labor'),
    ]),
    ContentBlock.text(paddingLeft: 20, [
      Data(text: '(5) Royal Thai Police'),
    ]),
    ContentBlock.text(paddingLeft: 20, [
      Data(
          text:
              '(6) Concerned people in the workplace of the customer when checking the credit'),
    ]),
    ContentBlock.text(paddingLeft: 20, [
      Data(
          text:
              '(7) Concerned people in the workplace of the customer or reference person of the customer for debt payment request'),
    ]),
    ContentBlock.text([
      Data(
          text:
              '4. The objective in collecting, using and disclosing personal data.'),
    ]),
    ContentBlock.text([
      Data(
          text:
              'The company has the objective in collecting, using and disclosing personal data as follows.'),
    ]),
    ContentBlock.text(paddingLeft: 10, [
      Data(
          text:
              'a. Application for loan, loan consideration and giving PICO FINANCE loan to customer'),
    ]),
    ContentBlock.text(paddingLeft: 10, [
      Data(text: 'b. Management of PICO FINANCE loan of the customer'),
    ]),
    ContentBlock.text(paddingLeft: 10, [
      Data(text: 'c. Customer service development'),
    ]),
    ContentBlock.text(paddingLeft: 10, [
      Data(text: 'd. Sales promotion activity'),
    ]),
    ContentBlock.text(paddingLeft: 10, [
      Data(text: 'e. Customer data analysis'),
    ]),
    ContentBlock.text(paddingLeft: 10, [
      Data(text: 'f. Product development'),
    ]),
    ContentBlock.text(paddingLeft: 10, [
      Data(text: 'g. Compliance with each type of law'),
    ]),
    ContentBlock.text([
      Data(
          text:
              'The company will collect, use and disclose personal data as necessary to the operation according to the objective above or as you have given the consent or there is permission from the Personal Data Protection Act B.E. 2562 (2019) or other concerned law.'),
    ]),
    ContentBlock.text([
      Data(text: '5. Disclosure of personal data to a third party'),
    ]),
    ContentBlock.text([
      Data(
          text:
              'The company might disclose personal data to a third party in the cases as follows.'),
    ]),
    ContentBlock.text(paddingLeft: 10, [
      Data(
          text:
              'a. Operation according to the law and request from government agency'),
    ]),
    ContentBlock.text(paddingLeft: 10, [
      Data(
          text:
              'b. Work operation concerning the agreement with the customer such as debt request'),
    ]),
    ContentBlock.text(paddingLeft: 10, [
      Data(
          text:
              'c. Work operation concerning customer service or marketing development such as work operation on improving advertisement concerning application via the website and/or the application of the company to have optimization.'),
    ]),
    ContentBlock.text([
      Data(
          text:
              'A third party to which the company might disclose the data might include foreign people or juristic entities which enforce the personal data protection law at the same level as Thailand or foreign people or juristic entities that does not have the level of personal data protection as Thailand.'),
    ]),
    ContentBlock.text([
      Data(text: '6. Storing and storing time of personal data'),
    ]),
    ContentBlock.text([
      Data(text: 'The company will keep personal data as follows.'),
    ]),
    ContentBlock.text(paddingLeft: 10, [
      Data(text: 'a. Storing characteristics'),
    ]),
    ContentBlock.text(paddingLeft: 20, [
      Data(text: 'Storing in writing and electronic means'),
    ]),
    ContentBlock.text(paddingLeft: 10, [
      Data(text: 'b. Storing place'),
    ]),
    ContentBlock.text(paddingLeft: 20, [
      Data(
          text:
              '1. In case of written documents, the company will store them in a room or cabinet with safety equipment.'),
    ]),
    ContentBlock.text(paddingLeft: 20, [
      Data(
          text:
              '2. In case of electronic means, the company will store them on a server installed in a room with safety equipment.'),
    ]),
    ContentBlock.text(paddingLeft: 10, [
      Data(
          text:
              'c. Storing time is counted from the day that the company receives data from conducting the business with the customer and the company for the last time.'),
    ]),
    ContentBlock.table([
      {
        'type': [
          Data(text: 'Type of personal data', style: CustomStyle.bodyBold())
        ],
        'period': [Data(text: 'Storing period', style: CustomStyle.bodyBold())]
      },
      {
        'type': [
          Data(
              text:
                  'Personal data such as name, date of birth, ID Number, address, telephone number, contact place'),
          Data(
              text: '(except conversation file, IP Address and Cookies)',
              style: CustomStyle.bodyItalic()),
        ],
        'period': [Data(text: '10 years')]
      },
      {
        'type': [Data(text: 'Conversation file')],
        'period': [Data(text: '2 years')]
      },
      {
        'type': [Data(text: 'Cookies')],
        'period': [Data(text: '1 year')]
      },
    ]),
    ContentBlock.text([
      Data(
          text:
              'Unless there is other cause according to the law that allows to keep longer such as to follow the law or to use the right according to the law.'),
    ]),
    ContentBlock.text(paddingLeft: 10, [
      Data(text: 'd. Operation after passing the storing period'),
    ]),
    ContentBlock.text(paddingLeft: 20, [
      Data(
          text:
              '1. As for the personal data collected in writing, company will destroy them in 3 months from the time after storing.'),
    ]),
    ContentBlock.text(paddingLeft: 20, [
      Data(
          text:
              '2. As for personal data collected via electronic means, the company will delete within 1 month from the time after storing.'),
    ]),
    ContentBlock.text([
      Data(text: '7. Right of the customer'),
    ]),
    ContentBlock.text([
      Data(text: 'The customer has the rights as follows.'),
    ]),
    ContentBlock.text(paddingLeft: 10, [
      Data(
          text:
              'a. Has the right in revoking consent. The customer has the right to revoke the consent for the entire period that the personal data of the customer is with the company.'),
    ]),
    ContentBlock.text(paddingLeft: 10, [
      Data(
          text:
              'b. Has the right to access personal data. The customer has the right to access their personal data and request the company to make a copy of such personal data to the customer and request the company to disclose the acquisition of the personal data of the customer that does not give consent to the company.'),
    ]),
    ContentBlock.text(paddingLeft: 10, [
      Data(
          text:
              'c. The right in revising personal data. The customer has the right in requesting the company to revise incorrect data, to add incomplete data or to revise misleading data.'),
    ]),
    ContentBlock.text(paddingLeft: 10, [
      Data(
          text:
              'd. The right to delete personal data. The customer is entitled to request the company to delete personal data of the customer by some reasons.'),
    ]),
    ContentBlock.text(paddingLeft: 10, [
      Data(
          text:
              'e. The right in stopping personal data, the customer has the right in stop using personal data of the customer by some reasons.'),
    ]),
    ContentBlock.text(paddingLeft: 10, [
      Data(
          text:
              'f. The right in transferring personal data. The customer has the right to transfer personal data of the customer that the customer has given to the company to other data controller or the customer themselves for some reason.'),
    ]),
    ContentBlock.text(paddingLeft: 10, [
      Data(
          text:
              'g. In objecting personal data collecting, using and disclosing, the customer has the right to object their personal data collecting, using and disclosing for some reasons.'),
    ]),
    ContentBlock.text(paddingLeft: 10, [
      Data(
          text:
              'h. The right in submitting complaint: the customer is entitled to submit the objection for violation in case the company violates the Personal Data Protection Act B.E. 2562 (2019).'),
    ]),
    ContentBlock.text([
      Data(
          text:
              'The customer can contact the officer of the personal data operation of the company to make a request according to the rights (the contact details are specified in No "15. Inquiry channel of personal data")'),
    ]),
    ContentBlock.text([
      Data(
          text:
              'The customer can verify the details of the conditions, exception to use the rights according to concerned law from the website of the Ministry of Digital Economy and Society ('),
      Data(
          text: 'http://www.mdes.go.th',
          url: 'http://www.mdes.go.th',
          style: CustomStyle.linkStyle()),
      Data(text: ').')
    ]),
    ContentBlock.text([
      Data(
          text:
              ' The customer does not have to pay for any expenses in following such right but in case of unreasonable submission of the request or overly expensive request which is not the case that the law specifies the personal data controller to be responsible to pay for the expense in such operation, the company might collect the fee from the customer as necessary.'),
    ]),
    ContentBlock.text([
      Data(
          text:
              'The company will consider the request of the customer and notify the consideration result within 30 days from the day that the company receives such request.'),
    ]),
    ContentBlock.text([
      Data(
          text:
              'In the following case, the company might need to deny request of the customer to follow the concerned law.'),
    ]),
    ContentBlock.text(paddingLeft: 10, [
      Data(
          text:
              'a. In case the customer cannot show clearly that the request maker is the owner of the data or have the power in such request.'),
    ]),
    ContentBlock.text(paddingLeft: 10, [
      Data(
          text:
              'b. Such request is unreasonable such as the customer has no right in accessing personal data or there is no such personal data at the company.'),
    ]),
    ContentBlock.text(paddingLeft: 10, [
      Data(
          text:
              'c. Such request is redundant request such as request with similar content or the same thing without reasonable cause etc.'),
    ]),
    ContentBlock.text(paddingLeft: 10, [
      Data(
          text:
              'd. That request might cause damage to the right and freedom of other people. For example, disclosure of those data is also disclosure of personal data of a third party or disclosure or intellectual property or trade secret of a third party.'),
    ]),
    ContentBlock.text(paddingLeft: 10, [
      Data(
          text:
              'e. Other causes as specified by the law such as following the law, following court order or to be used as defending right according to the law.'),
    ]),
    ContentBlock.text([
      Data(text: '8. Marketing activity and marketing promotion'),
    ]),
    ContentBlock.text([
      Data(
          text:
              'The company might send data concerning marketing activity and marketing promotion concerning the service provision of the company which the customer might be interested in for the benefit in using the service fully if the customer receives such news from the company. The customer is entitled to revoke the agreement and deny receiving such data from the company at any time.'),
    ]),
    ContentBlock.text([
      Data(text: '9. Definition of cookies'),
    ]),
    ContentBlock.text([
      Data(
          text:
              'Cookies are the data recorded in the computer or other electronic devices of the customer to collect the Log data details, website use of the customer or website visiting behavior of the customer including use history, the data that the customer filled out during use of the website on the internet which are recorded into the company of the customer when accessing the website. If the customer goes into the same website next time, the customer does not need to fill out the same data every sign-in and can change the display for each customer because it uses the reference from the cookies that the website controller records into the computer of the customer and if the customer allows cookies, the website can receive cookies from the browser of the customer.'),
    ]),
    ContentBlock.text([
      Data(text: '10. Using of cookies'),
    ]),
    ContentBlock.text([
      Data(
          text:
              'The company will collect website visit data from every customer visiting any items via the cookies or equivalent technology and the company will use the cookies for the benefit in developing the efficiency in accessing the service of the company via the internet and to develop the service use efficiency of the company via the internet by using other types of the company as follows.'),
    ]),
    ContentBlock.text(paddingLeft: 10, [
      Data(
          text:
              'a. So that the customer can Sign into the account of the customer in the website of the company without interruption.'),
    ]),
    ContentBlock.text(paddingLeft: 10, [
      Data(
          text:
              'b. A third party that the company employs to publicize collect cookies from the website of the company for improving the advertising to suit the customer the most.'),
    ]),
    ContentBlock.text([
      Data(text: '11. Type of cookies used by the company'),
    ]),
    ContentBlock.text([
      Data(
          text:
              'The company uses the following cookies for the website of the company.'),
    ]),
    ContentBlock.text(paddingLeft: 10, [
      Data(
          text:
              'a. Functionality used in recognizing the things that the customer chose as preferences such as default language etc.'),
    ]),
    ContentBlock.text(paddingLeft: 10, [
      Data(
          text:
              'b. Advertising used in recognizing the items that customer used to visit to present the goods, service or concerned advertising media to follow the interest of the customer.'),
    ]),
    ContentBlock.text([
      Data(text: '12. Cookie management'),
    ]),
    ContentBlock.text([
      Data(
          text:
              'The customer can block the function of cookies by specifying in the browser of the customer which the customer can deny installation of all or some type of cookies but please note that if the customer specifies the browser of the customer to block all the cookies (including necessary cookies for the operation), the customer might not be able to access all or some part of the website of the company.'),
    ]),
    ContentBlock.text([
      Data(
          text:
              'Configuration to prevent the browser of the customer to accept the cookies of the company has the cookies management procedure as follows.'),
    ]),
    ContentBlock.text([
      Data(text: 'Configuration procedure'),
    ]),
    ContentBlock.text(paddingLeft: 10, [
      Data(text: 'a. Google Chrome'),
    ]),
    ContentBlock.text(paddingLeft: 10, [
      Data(
          text: 'https://support.google.com/chrome/answer/95647?hl=th',
          url: 'https://support.google.com/chrome/answer/95647?hl=th',
          style: CustomStyle.linkStyle()),
    ]),
    ContentBlock.text(paddingLeft: 10, [
      Data(text: 'b. Safari'),
    ]),
    ContentBlock.text(paddingLeft: 10, [
      Data(
          text: 'https://support.apple.com/th-th/guide/safari/sfri11471/mac',
          url: 'https://support.apple.com/th-th/guide/safari/sfri11471/mac',
          style: CustomStyle.linkStyle()),
    ]),
    ContentBlock.text(paddingLeft: 10, [
      Data(text: 'c. Internet Explorer'),
    ]),
    ContentBlock.text(paddingLeft: 10, [
      Data(
          text:
              'https://support.microsoft.com/th-th/help/17442/windows-internet-explorer-delete-manage-cookies',
          url:
              'https://support.microsoft.com/th-th/help/17442/windows-internet-explorer-delete-manage-cookies',
          style: CustomStyle.linkStyle()),
    ]),
    ContentBlock.text([
      Data(
          text:
              '13. Data protection policy of other websites through the company'),
    ]),
    ContentBlock.text([
      Data(
          text:
              'The personal data protection policy of the company is used only to provide the service of the company and using the website of the company only. This personal data protection policy is not applied with other websites apart from the website of the company even if other websites are accessed through the website of the company.'),
    ]),
    ContentBlock.text([
      Data(
          text:
              'Therefore, please study the personal data protection policy in other websites which are not the website of the company to understand the way that such website might use the data of the customer.'),
    ]),
    ContentBlock.text([
      Data(text: '14.Change of personal data protection policy'),
    ]),
    ContentBlock.text([
      Data(
          text:
              'The company will review and change this personal data protection policy regularly to follow the law and regulation concerned or in case it is necessary for work operation.'),
    ]),
    ContentBlock.text([
      Data(
          text:
              'If there is a change of this personal data protection policy, the company might notify through the website of the company.'),
    ]),
    ContentBlock.text([
      Data(text: '15. Inquiry channel concerning personal data'),
    ]),
    ContentBlock.text(paddingLeft: 10, [
      Data(text: '1. Inquiry channel inside the company'),
    ]),
    ContentBlock.text(paddingLeft: 20, [
      Data(text: 'Personal data operation officer'),
    ]),
    ContentBlock.text(paddingLeft: 20, [
      Data(text: 'Duangrat Wattapongchat'),
    ]),
    ContentBlock.text(paddingLeft: 20, [
      Data(
          text: 'Tel. +6681-822-5285',
          phoneNumber: '+66818225285',
          style: CustomStyle.linkStyle()),
    ]),
    ContentBlock.text(paddingLeft: 20, [
      Data(
          text: 'https://www.synpitarn.com',
          url: 'https://www.synpitarn.com',
          style: CustomStyle.linkStyle())
    ]),
    ContentBlock.text(paddingLeft: 10, [
      Data(text: '2. Inquiry channel outside the company'),
    ]),
    ContentBlock.text([
      Data(text: 'The office of personal data protection committee'),
    ]),
    ContentBlock.text([
      Data(text: '16. Making and updating the personal data protection policy'),
    ]),
    ContentBlock.text([
      Data(
          text:
              'Making and updating the personal data protection policy of the company is as follows. Made on 1st September 2022'),
    ])
  ];
}
