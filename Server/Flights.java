import java.util.ArrayList;

public class Flights {
    private String data;

    public Flights(String data) {
        this.data = data;
    }

    public String getData() {
        return data;
    }

    String FlightSearchResult() {
        String[] split = data.split("-");
        String str = DataBase.getInstance().getController("Flights").getRows(split[0],1,split[1],2,split[2],5);
        if(str.equals("invalid")){
            return "noFlights";
        }else{
            return str;
        }
    }

    String buyFlight(){
        String[] split = data.split("-");
        Accounting accounting = new Accounting(split[0]);
        if(split[1].equals("true")){
            String flight1 = split[2].split("\\\\")[0];
            String flight2 = split[2].split("\\\\")[1];
            int neededMoney = Integer.parseInt(split[3])*(Integer.parseInt(flight1.split("/")[4]) + Integer.parseInt(flight2.split("/")[4]));
            int budget = Integer.parseInt(accounting.getBudget());
            if(neededMoney > budget){
                return "notEnoughMoney";
            }else{
                accounting.changeBudget(Integer.toString(budget - neededMoney));
                String write = split[0] + "-" + flight1.replace("/","-").replace("#","/")+"\n";
                DataBase.getInstance().getController("BuyedFlights").writeFile(write);
                write = split[0] + "-" + flight2.replace("/","-").replace("#","/");
                DataBase.getInstance().getController("BuyedFlights").writeFile(write);
                accounting.setTransaction(split[0]+"-decrease-"+Integer.toString(neededMoney));
                return "valid";
            }
        }else{
            String flight1 = split[2].split("\\\\")[0];
            int neededMoney = Integer.parseInt(split[3])*(Integer.parseInt(flight1.split("/")[4]));
            int budget = Integer.parseInt(accounting.getBudget());
            if(neededMoney > budget){
                return "notEnoughMoney";
            }else{
                accounting.changeBudget(Integer.toString(budget - neededMoney));
                String write = split[0] + "-" + flight1.replace("/","-").replace("#","/");
                DataBase.getInstance().getController("BuyedFlights").writeFile(write);
                accounting.setTransaction(split[0]+"-decrease-"+Integer.toString(neededMoney));
                return "valid";
            }
        }
    }

    String FlightBookingDomestic(){
        String domesicFlights = DataBase.getInstance().getController("Flights").getRows("domestic",7);
        String[] split = domesicFlights.split("\n");
        String sources = "";
        String destinations = "";
        for (String str : split) {
            sources += str.split("-")[1];
            sources += "-";
            destinations += str.split("-")[2];
            destinations += "-";
        }
        return sources + destinations;
    }
    

    String FlightBookingInt(){
        String domesicFlights = DataBase.getInstance().getController("Flights").getRows("int",7);
        String[] split = domesicFlights.split("\n");
        String sources = "";
        String destinations = "";
        for (String str : split) {
            sources += str.split("-")[1];
            sources += "-";
            destinations += str.split("-")[2];
            destinations += "-";
        }
        return (sources + destinations);
    }
 
    String getUserFlights(){
        String str = DataBase.getInstance().getController("BuyedFlights").getRows(data,0);
        if(str.equals("invalid")){
            return "noFlights";
        }else{
            return str;
        }
    }

    String addFlight(){
        DataBase.getInstance().getController("Flights").writeFile(data);
        return "The Flight aded successfully.";
    }

    String checkFlightNumber(){
        String str = DataBase.getInstance().getController("Flights").getRows(data.split("-")[0], 0, data.split("-")[1], 6);
        if(str.equals("invalid")){
            return "invalid";
        }else{
            return "valid";
        }
    }

    String deleteFlight(){
        String wholeFile = DataBase.getInstance().getController("Flights").readFile();
        String[] lines = wholeFile.split("\n");
        String str = "";
        for (int i=0;i<lines.length;i++) {
            if (!(lines[i].split("-")[0].equals(data.split("-")[0]) && lines[i].split("-")[6].equals(data.split("-")[1]))) {
                str += lines[i];
                str += "\n";
            }
        }
        DataBase.getInstance().getController("Flights").writeFile(str,true);
        return "the Flight deleted successfully.";
    }

    String SelloutTickets(){
        if(DataBase.getInstance().getController("BuyedFlights").readFile().equals("")){
            return "invalid";
        }else{
        return DataBase.getInstance().getController("BuyedFlights").getRows(data,1);
        }
    }

    String calculateAverageEarnings(String duration){
        if(DataBase.getInstance().getController("BuyedFlights").readFile().equals("")){
            return "no sellout Flights";
        }else{
        String str = DataBase.getInstance().getController("BuyedFlights").getRows(data,1);
        if(str.equals("invalid")){
            return "no sellout Flights";
        }else{
            String[] split = str.split("\n");
            int sum =0;
            for(String line : split){
                sum += Integer.parseInt(line.split("-")[5]);
            }
            int average = sum / Integer.parseInt(duration);
            return Integer.toString(average);
        }
    }
    }

    String mostSelledTicket(){
        if(DataBase.getInstance().getController("BuyedFlights").readFile().equals("")){
            return "no sellout Flights";
        }else{
        String wholeFile = DataBase.getInstance().getController("BuyedFlights").getRows(data,1);
        
        if(wholeFile.equals("invalid")){
            return "no sellout Flights";
        }else{
        String[] lines = wholeFile.split("\n");
        ArrayList<String> flightNumbers=  new ArrayList<String>();
        for(String line : lines){
            if(flightNumbers.contains(line.split("-")[7])==false){
                flightNumbers.add(line.split("-")[7]);
            }
        }
        int[] amounts = new int[flightNumbers.size()];
        for(int i=0;i<amounts.length;i++){
            amounts[i]=0;
        }
        for(String line : lines){
            for(int i=0;i<flightNumbers.size();i++){
                if(line.split("-")[7].equals(flightNumbers.get(i))){
                    amounts[i]++;
                }
            }
        }
        int maxindex =0;
        int max=0;
        for (int i=0;i<amounts.length;i++){
            if(amounts[i]>max){
                maxindex = i;
                max = amounts[i];
            }
        }
        String flightNumber = flightNumbers.get(maxindex);
        return DataBase.getInstance().getController("Flights").getRows(flightNumber,6);
        }
    }
    }
}
