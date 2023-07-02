public class CompanyAccount {
    private String data;

    public CompanyAccount(String data) {
        this.data = data;
    }

    public String getData() {
        return data;
    }

    String checkUsername() {
        if(DataBase.getInstance().getController("CompaniesBasicInfo").getRow(data).equals("invalid")){
        return "valid";
        }else{
            return "invalid";
        }
    }

    String checkCompany() {
        if(DataBase.getInstance().getController("Companies").getRow(data).equals("invalid")){
        return "invalid";
        }else{
            return "valid";
        }
    }

    String getCompany(){
        return DataBase.getInstance().getController("CompaniesBasicInfo").getRow(data).split("-")[2];
    }

    String signUp() {
        DataBase.getInstance().getController("CompaniesBasicInfo").writeFile(data+"\n");
        DataBase.companyCounter++;
        return "valid";
    }

    String Login() {
        String line = DataBase.getInstance().getController("CompaniesBasicInfo").getRow(data.split("-")[0]);
        if(line.equals("invalid")){
            return "notFound";
        }else{
            if(line.split("-")[1].equals(data.split("-")[1])){
                return "valid";
            }else{
                return "passinvalid";
            }
        }
    }

    String GetAvailableFlights(){
        String str = DataBase.getInstance().getController("Flights").getRows(data,0);
        if(str.equals("invalid")){
            return "noFlights";
        }else{
            return str;
        }
    }

}
