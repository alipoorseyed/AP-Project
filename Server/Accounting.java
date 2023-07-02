public class Accounting{
    private String data;

    public Accounting(String data) {
        this.data = data;
    }

    public String getData() {
        return data;
    }

    String getBudget() {
        String str = DataBase.getInstance().getController("Budget").getRow(data);
        return str.split("-")[1];
    }

    void changeBudget(String newBudget){
        String wholeFile = DataBase.getInstance().getController("Budget").readFile();
        String[] lines = wholeFile.split("\n");
        String str = "";
        for (int i=0;i<lines.length;i++) {
            if (lines[i].startsWith(data)) {
                lines[i] = data + "-" + newBudget;
            }
            str += lines[i];
            str += "\n";
        }
        DataBase.getInstance().getController("Budget").writeFile(str,true);
    }

    String increaseBudget(String amount,String Paygiri_Code){
        int CurrentBudget = Integer.parseInt(this.getBudget());
        int Budget = CurrentBudget + Integer.parseInt(amount);
        this.changeBudget(Integer.toString(Budget));
        this.setTransaction(data+"-"+"increase-" + amount,Paygiri_Code);
        return Integer.toString(Budget) + "\n" + DataBase.getInstance().getController("Transactions").getRows(data,0);
    }

    String MoneyPage(){
        return getBudget() + "\n" + DataBase.getInstance().getController("Transactions").getRows(data,0);
    }

    void setTransaction(String TransactionData){
        int Paygiri_Code = DataBase.getInstance().getController("Transactions").readFile().length();
        Paygiri_Code += 100001;
        String PaygiriCode = Integer.toString(Paygiri_Code);
        DataBase.getInstance().getController("Transactions").writeFile(TransactionData+"-"+PaygiriCode+"\n");
    }

    void setTransaction(String TransactionData,String Paygiri_Code){
        DataBase.getInstance().getController("Transactions").writeFile(TransactionData+"-"+Paygiri_Code+"\n");
    }

    String CheckDiscount(){
        String str = DataBase.getInstance().getController("DiscountCodes").getRow(data);
        if(str.equals("invalid")){
            return "invalid";
        }else{
            return str.split("-")[1];
        }
    }
}
