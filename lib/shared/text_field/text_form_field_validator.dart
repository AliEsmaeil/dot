
  String?Function(String?) getValidateFunction({required String errorMessage}){

      String? validate(String? txt){

       if(txt!.isEmpty){
         return errorMessage;
       }
       return null;
     }
     return validate;
  }
