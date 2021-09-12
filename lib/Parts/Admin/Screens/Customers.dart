import 'package:Shopping/Parts/Admin/InnerScreen/InnerCustomers/CustomerInfo.dart';
import 'package:Shopping/Providers/AuthProvider.dart';
import 'package:Shopping/Services/Constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Customers extends StatefulWidget {

  static const String CUSTOMERS = "/Customers";

  @override
  _CustomersState createState() => _CustomersState();
}

class _CustomersState extends State<Customers> {

  String search  = "";

  @override
  Widget build(BuildContext context) {

    Size size = MediaQuery.of(context).size ;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Consumer<AuthProvider>(
        builder: (context , value , child)
        => StreamBuilder(
          stream: value.getUsers(),
          builder: (context , AsyncSnapshot<List<QueryDocumentSnapshot>> snapshot)
          => Container(
            padding: EdgeInsets.symmetric(horizontal: 5 ,vertical: 10),
            width: size.width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Container(
                  width: double.infinity,
                  child: TextField(
                    maxLines: 1,
                    keyboardType: TextInputType.text,
                    style: TextStyle(color: Colors.black,fontSize: 19),
                    textAlignVertical: TextAlignVertical.center,
                    decoration: InputDecoration(
                       hintText: "Customer name",
                      hintStyle: TextStyle(color: Colors.grey,fontSize: 16),
                      contentPadding: EdgeInsets.all(5),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                        borderSide: BorderSide(color: Colors.orange,width: 1),
                      ),
                      suffixIcon: Icon(Icons.search,color: Colors.orange,),
                      border: InputBorder.none
                    ),
                    onChanged: (val)=> setState(()=> search = val.trim().toLowerCase()),
                  ),
                ),
                SizedBox(height: 10,),
                Expanded(
                  child: ListView.separated(
                    physics: BouncingScrollPhysics(),
                    separatorBuilder: (context , space)=> SizedBox(height: 10,),
                    itemCount: snapshot.hasData ? _listCustomers(snapshot.data!).length : 0,
                    itemBuilder: (context , index)
                    => snapshot.hasData ?Container(
                      width: double.infinity,
                      height: size.height*.09,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(5),
                                child: Image.network(
                                  _listCustomers(snapshot.data!)[index][Constants.IMAGEUSER],
                                  filterQuality: FilterQuality.high,
                                  fit: BoxFit.cover,
                                  height: size.height*0.4,
                                  width: size.width*0.2,
                                ),
                              ),
                              SizedBox(width: 5,),
                              Padding(
                                padding: const EdgeInsets.all(5),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(userInfo(_listCustomers(snapshot.data!)[index][Constants.NAME], 20),style: TextStyle(color: Colors.black,fontSize:18 ,fontWeight: FontWeight.w600),),
                                    Text(userInfo(_listCustomers(snapshot.data!)[index][Constants.EMAIL], 25),style: TextStyle(color: Colors.grey,fontSize:15 ,fontWeight: FontWeight.w300),),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          IconButton(
                            icon: Icon(Icons.remove_red_eye,color: Colors.blueGrey,),
                            onPressed: ()=> Navigator.of(context)
                                .push(MaterialPageRoute(builder: (_)
                            => CustomerInfo(customerId:_listCustomers(snapshot.data!)[index][Constants.IDUSER]))),
                          )
                        ],
                      )
                    ): Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children:
                        [
                          Text("Waiting",style: TextStyle(fontSize: 18,color: Colors.black26),),
                          SizedBox(width: 10,),
                          CircularProgressIndicator(color: Colors.black26,strokeWidth: 2,)
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      )
    );
  }

  String userInfo (String info , int textLength){

    if(info.length > textLength){
     return Constants.showTextEn(info: info.substring(0,textLength))+"...";
    }else{
      return Constants.showTextEn(info: info);
    }

  }

  List<QueryDocumentSnapshot> _listCustomers(List<QueryDocumentSnapshot> list ){

    List<QueryDocumentSnapshot> customers = [];

    return customers = search.isEmpty ? list : list.where((element)
     => element.get(Constants.NAME).toString().toLowerCase().contains(search)).toList();
  }

}
/*Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    InkWell(
                                      borderRadius: BorderRadius.circular(10),
                                      splashColor: Colors.green.shade100,
                                      child: Icon(Icons.remove_red_eye ,color: Colors.green,),
                                      onTap: (){},
                                    ),
                                    SizedBox(width: 15,),
                                    ...userPermissions.map((permission)
                                    => Row(
                                      children: [
                                        Radio(
                                          value: permission,
                                          groupValue: changePermission,
                                          onChanged: (value){
                                            setState(() {
                                              changePermission = value.toString();
                                            });
                                          },
                                        ),
                                        Text(permission.contains(Constants.SuperAdmin) ? "S.admin" : permission.contains(Constants.Admin)? "admin" : "customer",
                                          style: TextStyle(color: Colors.black),
                                        )
                                      ],
                                    ),
                                    ),
                                  ],
                                )*/