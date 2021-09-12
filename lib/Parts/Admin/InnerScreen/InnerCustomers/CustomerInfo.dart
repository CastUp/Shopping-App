import 'package:Shopping/Providers/AuthProvider.dart';
import 'package:Shopping/Services/Constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:list_tile_switch/list_tile_switch.dart';
import 'package:provider/provider.dart';

class CustomerInfo extends StatefulWidget {
  
  late String customerId ;

  CustomerInfo({required this.customerId});

  @override
  _CustomerInfoState createState() => _CustomerInfoState();
}


class _CustomerInfoState extends State<CustomerInfo> {

  FirebaseAuth _auth           = FirebaseAuth.instance ;
  List<String> userPermissions = [Constants.SuperAdmin,Constants.Admin,Constants.Customer];
  DocumentSnapshot? info ;

  String name      = "";
  String email     = "";
  String phone     = "";
  String address   = "";
  String image     = "";
  String promotion = "";
  String joinedAt  = "";

  Future<void> getCustomerInfo() async {

    info = await Provider.of<AuthProvider>(context,listen: false).getUserFuture(idUser: widget.customerId);

    name      = info!.get(Constants.NAME);
    email     = info!.get(Constants.EMAIL);
    phone     = info!.get(Constants.PHONE);
    address   = info!.get(Constants.ADDRESS);
    image     = info!.get(Constants.IMAGEUSER);
    promotion = info!.get(Constants.PROMOTION);
    joinedAt  = info!.get(Constants.JOINEDAT);
    setState(() {});
  }

  @override
  void initState() {
    getCustomerInfo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    
    Size size = MediaQuery.of(context).size ;
    
    return Consumer<AuthProvider>(
      builder: (context , provider , child)
      => Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.orange.shade700,
          title: Text(info != null ? userInfo(name, 20) : "",style: TextStyle(color: Colors.white,fontSize: 22),),
          centerTitle: true,
          elevation: 0,
        ),
        body: Stack(
          children: [
            Container(
              width: size.width,
              height: size.height*.25,
              decoration: BoxDecoration(
                color: Colors.orange.shade700,
                borderRadius: BorderRadius.only(bottomLeft: Radius.circular(size.width/2),bottomRight: Radius.circular(size.width/2))
              ),
              child: info != null ? Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  FittedBox(
                    child: RichText(
                      maxLines: 1,
                      text: TextSpan(
                          children: <TextSpan>[
                            TextSpan(text: "Email: ",style: TextStyle(color: Colors.black54,fontWeight: FontWeight.bold,fontSize: 14)),
                            TextSpan(text: userInfo(email, 25),style: TextStyle(color: Colors.white,fontWeight: FontWeight.w500,fontSize: 13)),
                          ]
                      ),
                    ),
                  ),
                  SizedBox(height: 10,),
                  FittedBox(
                    child: RichText(
                      maxLines: 1,
                      text: TextSpan(
                          children: <TextSpan>[
                            TextSpan(text: "Phone: ",style: TextStyle(color: Colors.black54,fontWeight: FontWeight.bold,fontSize: 14)),
                            TextSpan(text: userInfo(phone.isEmpty ? "Not added yet": phone, 30),style: TextStyle(color: Colors.white,fontWeight: FontWeight.w500,fontSize: 13)),
                          ]
                      ),
                    ),
                  ),
                  SizedBox(height: 10,),
                  FittedBox(
                    child: RichText(
                      maxLines: 1,
                      text: TextSpan(
                          children: <TextSpan>[
                            TextSpan(text: "Promotion: ",style: TextStyle(color: Colors.black54,fontWeight: FontWeight.bold,fontSize: 14)),
                            TextSpan(text: userInfo(Constants.customerPromotion(promotion), 20),style: TextStyle(color: Colors.white,fontWeight: FontWeight.w500,fontSize: 13)),
                          ]
                      ),
                    ),
                  ),
                  SizedBox(height: 10,),
                  FittedBox(
                    child: RichText(
                      maxLines: 1,
                      text: TextSpan(
                          children: <TextSpan>[
                            TextSpan(text: "Joined: ",style: TextStyle(color: Colors.black54,fontWeight: FontWeight.bold,fontSize: 14)),
                            TextSpan(text: userInfo(joinedAt, 20),style: TextStyle(color: Colors.white,fontWeight: FontWeight.w500,fontSize: 13)),
                          ]
                      ),
                    ),
                  ),
                ],
              ) : Container(),
            ),
            info != null ? Align(
             alignment: Alignment(0,Constants.screenHeightSize(context, -.60, -.70)),
             child: Container(
                width: size.width*.30,
                height: size.height*.30,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: NetworkImage(image),
                    fit: BoxFit.cover,
                  ),
                  border: Border.all(color: Colors.black,width: 1)
                ),
              ),
           ) : Align(
             alignment: Alignment(0,-.70),
             child: Container(
               width: size.width*.30,
               height: size.height*.30,
               decoration: BoxDecoration(
                   shape: BoxShape.circle,
                   color: Colors.orange.shade700.withOpacity(0.7),
                   border: Border.all(color: Colors.black,width: 1)
               ),
             ),
           ),
            SizedBox(height: 30,),
            Positioned(
              top: size.height*.36,
              left: 5,
              right: 5,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(horizontal: 8 ,vertical: 10),
                    decoration: BoxDecoration(
                        color: Colors.black12,
                        borderRadius: BorderRadius.circular(5)
                    ),
                    child:Wrap(
                      children: [
                        Icon(Icons.home_outlined,size: 18,color: Colors.indigo,),
                        RichText(
                          text: TextSpan(
                              children: <TextSpan>[
                                TextSpan(text: "address: "+"\n\n",style: TextStyle(color: Colors.red,fontWeight: FontWeight.bold,fontSize: 14)),
                                TextSpan(text:Constants.showTextEn(info: address.isEmpty ? "not added yet": address),style: TextStyle(color: address.isEmpty ? Colors.blueGrey: Colors.black,fontWeight: FontWeight.w400,fontSize: 13)),
                              ]
                          ),
                        ),
                      ],
                    )
                  ),
                  SizedBox(height: 15,),
                  widget.customerId.contains(_auth.currentUser!.uid) ? Container() :
                  Container(
                      decoration: BoxDecoration(
                          color: Colors.black12,
                          borderRadius: BorderRadius.circular(5)
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          ...userPermissions.map((promo)
                          => Row(
                            children: [
                              Radio(
                                value: promo,
                                groupValue: promotion,
                                onChanged: (value){
                                  provider.changePromotion(context, idUser: widget.customerId, promotion: value.toString())
                                  .then((change) => change ? setState(()=> promotion = value.toString()) : null);
                                },
                              ),
                              Text(promo.contains(Constants.SuperAdmin) ? "S.admin" : promo.contains(Constants.Admin)? "Admin" : "Customer",
                                style: TextStyle(color: Colors.black),
                              )
                            ],
                          ),
                          ),
                        ],
                      )
                  ),
                ],
              ),
            ),
           ]
        ),
      ),
    );
  }

  String userInfo (String info , int textLength){

    if(info.length > textLength){
      return Constants.showTextEn(info: info.substring(0,textLength))+"...";
    }else{
      return Constants.showTextEn(info: info);
    }

  }

}

