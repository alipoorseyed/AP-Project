public class ClientAccount {
    private String data;

    public ClientAccount(String data) {
        this.data = data;
    }

    public String getData() {
        return data;
    }

    String signUp() {
        if(DataBase.getInstance().getController("UsersBasicInfo").getRow(data.split("-")[0]).equals("invalid")){
        DataBase.getInstance().getController("UsersBasicInfo").writeFile(data+"\n");
        DataBase.clientCounter++;
        DataBase.getInstance().getController("Budget").writeFile(data.split("-")[0] + "-0" +"\n");
        DataBase.getInstance().getController("UsersInfo").writeFile(data.split("-")[0] +"-" + data.split("-")[2]+ "-empty-empty-empty-empty" +"\n");
        return "valid";
        }else{
            return "invalid";
        }
    }

    String Login() {
        String line = DataBase.getInstance().getController("UsersBasicInfo").getRow(data.split("-")[0]);
        if(line.equals("invalid")){
            return "findError";
        }else{
            if(line.split("-")[1].equals(data.split("-")[1])){
                return "valid";
            }else{
                return "passinvalid";
            }
        }
    }

    String GetInfo(){
        String Info = "";
        String line = DataBase.getInstance().getController("UsersBasicInfo").getRow(data);
        Info += line.split("-")[1]+"-";
        line = DataBase.getInstance().getController("Budget").getRow(data);
        Info += line.split("-")[1]+"-";
        line = DataBase.getInstance().getController("UsersInfo").getRow(data);
        String[] split = line.split("-");
        Info += split[1]+"-"+split[2]+"-"+split[3]+"-"+split[4]+"-"+split[5];
        return Info;
    }

    String changePassword(String newPass){
        String wholeFile = DataBase.getInstance().getController("UsersBasicInfo").readFile();
        String[] lines = wholeFile.split("\n");
        String str = "";
        for (int i=0;i<lines.length;i++) {
            if (lines[i].startsWith(data)) {
                lines[i] = lines[i].split("-")[0] + "-" + newPass + "-" + lines[i].split("-")[2];
            }
            str += lines[i];
            str += "\n";
        }
        DataBase.getInstance().getController("UsersBasicInfo").writeFile(str,true);
        return "valid";
    }

    String changeEmail(String newEmail){
        String wholeFile = DataBase.getInstance().getController("UsersBasicInfo").readFile();
        String[] lines = wholeFile.split("\n");
        String str = "";
        for (int i=0;i<lines.length;i++) {
            if (lines[i].startsWith(data)) {
                lines[i] = lines[i].split("-")[0] + "-" + lines[i].split("-")[1] + "-" + newEmail;
            }
            str += lines[i];
            str += "\n";
        }
        DataBase.getInstance().getController("UsersBasicInfo").writeFile(str,true);

        wholeFile = DataBase.getInstance().getController("UsersInfo").readFile();
        lines = wholeFile.split("\n");
        str = "";
        for (int i=0;i<lines.length;i++) {
            if (lines[i].startsWith(data)) {
                lines[i] = lines[i].split("-")[0] + "-" + newEmail + "-" + lines[i].split("-")[2]
                + "-" + lines[i].split("-")[3] + "-" + lines[i].split("-")[4] + "-" + lines[i].split("-")[5];
            }
            str += lines[i];
            str += "\n";
        }
        DataBase.getInstance().getController("UsersInfo").writeFile(str,true);
        return "valid";
    }

    String changeInfo(){
        String wholeFile = DataBase.getInstance().getController("UsersInfo").readFile();
        String[] lines = wholeFile.split("\n");
        String str = "";
        String[] split = data.split("-");
        for (int i=0;i<lines.length;i++) {
            if (lines[i].startsWith(data.split("-")[0])) {
                lines[i] = lines[i].split("-")[0] + "-" + lines[i].split("-")[1] + "-" + data.split("-")[1]
                + "-" + data.split("-")[2] + "-" + data.split("-")[3] + "-" + data.split("-")[4];
            }
            str += lines[i];
            str += "\n";
        }
        DataBase.getInstance().getController("UsersInfo").writeFile(str,true);
        return "valid";
    }

}
