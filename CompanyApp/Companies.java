import java.io.DataInputStream;
import java.io.DataOutputStream;
import java.io.IOException;
import java.net.Socket;
import java.util.Scanner;

public class Companies{
    static String source,destination,time,price,date,flightNumber,kind;
    static String username,password,company;
    static String response ;

    public static void main(String[] args) throws IOException {
        Scanner scan = new Scanner(System.in);
        ResponseHandler socket;
        System.out.println("1.Login\n2.SignUp");
        int choise = scan.nextInt();
        if(choise == 2){
            for(;;){
                System.out.print("UserName : ");
                username = scan.next();
                socket = new ResponseHandler();
                socket.writer("company-checkUsername-"+username+",");
                response = socket.listener().trim();
                socket.closeSocket();
                if(response.equals("valid")){
                    System.out.print("Password : ");
                    password = scan.next();
                    company = scan.nextLine();
                    for(;;){
                        System.out.print("Your Company : ");
                        company = scan.nextLine();
                        socket = new ResponseHandler();
                        socket.writer("company-checkCompany-"+company+",");
                        response = socket.listener().trim();
                        socket.closeSocket();
                        if(response.equals("valid")){
                            socket = new ResponseHandler();
                            socket.writer("company-signup-"+username+"-"+password+"-"+company+",");
                            response = socket.listener().trim();
                            socket.closeSocket();
                            showMenu(company);
                            break;
                        }else{
                            System.out.println("There is no company with that name.");
                        }
                    }
                    break;
                }else{
                    System.out.println("This Username is Already used.");
                }
            }
        }else{
            for(;;){
                System.out.print("UserName : ");
                username = scan.next();
                System.out.print("Password : ");
                password = scan.next();
                socket = new ResponseHandler();
                socket.writer("company-Login-"+username+"-"+ password +",");
                response = socket.listener().trim();
                socket.closeSocket();
                if(response.equals("valid")){
                    socket = new ResponseHandler();
                    socket.writer("company-getCompany-"+username+",");
                    company = socket.listener().trim();
                    socket.closeSocket();
                    showMenu(company);
                    break;                 
                }else if(response.equals("notFound")){
                    System.out.println("Username not found.");
                }else{
                    System.out.println("password is wrong.");
                }
            }
        }
    }

    static void showMenu(String company_) throws IOException{
        ResponseHandler socket;
        System.out.println("1.Available Flights");
        System.out.println("2.see Sellout Tickets");
        System.out.println("3.Analyze Company Sells");
        Scanner scan = new Scanner(System.in);
        int choise = scan.nextInt();
        switch(choise){
            case 1:
            showFlights(company_);
            AvailableFlightsMenu(company_);
            break;
            case 2:
            seeSelloutTickets(company_);
            break;
            case 3:
            System.out.println("choose duration :\n1. 1 month\n2. 3 months\n3. 6 months\n4. 1 year");
            choise = scan.nextInt();
            switch(choise){
                case 1:
                socket = new ResponseHandler();
                socket.writer("company-mostSelledTicket-"+company_+",");
                response = socket.listener().trim();
                socket.closeSocket();
                System.out.println("the most selled Flight of the company is: " + response);
                socket = new ResponseHandler();
                socket.writer("company-getAverageEarnings-"+company_+"-"+"30"+",");
                response = socket.listener().trim();
                socket.closeSocket();
                System.out.println("Average company Earnings in a day is : " + response);
                showMenu(company_);
                break;
                case 2:
                socket = new ResponseHandler();
                socket.writer("company-mostSelledTicket-"+company_+",");
                response = socket.listener().trim();
                socket.closeSocket();
                System.out.println("the most selled Flight of the company is: " + response);
                socket = new ResponseHandler();
                socket.writer("company-getAverageEarnings-"+company_+"-"+"90"+",");
                response = socket.listener().trim();
                socket.closeSocket();
                System.out.println("Average company Earnings in a day is : " + response);
                showMenu(company_);
                break;
                case 3:
                socket = new ResponseHandler();
                socket.writer("company-mostSelledTicket-"+company_+",");
                response = socket.listener().trim();
                socket.closeSocket();
                System.out.println("the most selled Flight of the company is: " + response);
                socket = new ResponseHandler();
                socket.writer("company-getAverageEarnings-"+company_+"-"+"180"+",");
                response = socket.listener().trim();
                socket.closeSocket();
                System.out.println("Average company Earnings in a day is : " + response);
                showMenu(company_);
                break;
                case 4:
                socket = new ResponseHandler();
                socket.writer("company-mostSelledTicket-"+company_+",");
                response = socket.listener().trim();
                socket.closeSocket();
                System.out.println("the most selled Flight of the company is: " + response);
                socket = new ResponseHandler();
                socket.writer("company-getAverageEarnings-"+company_+"-"+"360"+",");
                response = socket.listener().trim();
                socket.closeSocket();
                System.out.println("Average company Earnings in a day is : " + response);
                showMenu(company_);
                break;
            }
        }
    }

    static void showFlights(String company_)throws IOException{
        ResponseHandler socket;
        socket = new ResponseHandler();
        socket.writer("company-AvailableFlights-"+company_+",");
        response = socket.listener().trim();
        socket.closeSocket();
        System.out.print("-------------------------------------------------------\n");
        System.out.print(response+"\n");
        System.out.print("-------------------------------------------------------\n");
    }

    static void AvailableFlightsMenu(String company_)throws IOException{  
        ResponseHandler socket; 
        System.out.println("1.Add Flight");
        System.out.println("2.Delete Flight");
        System.out.println("3.Change Flight");
        System.out.println("4.Back to Menu");
        Scanner scan = new Scanner(System.in);
        int choise = scan.nextInt();
        switch(choise){
            case 1:
                 System.out.print("source : ");
                 source = scan.next();
                 System.out.print("destination : ");
                 destination = scan.next();
                 System.out.print("time : ");
                 time = scan.next();
                 System.out.print("price : ");
                 price = scan.next();
                 System.out.print("date(year/month/day) : ");
                 date = scan.next();
                 System.out.print("Flight number : ");
                 flightNumber = scan.next();
                 System.out.print("kind (international/domestic) : ");
                 kind = scan.next();
                 if(kind.equals("international")){
                 kind = "int";
                 }
                 socket = new ResponseHandler();
                 socket.writer("company-addFlight-"+company_+"-"+source+"-"+destination+"-"+time+"-"+price+"-"+date+"-"+flightNumber+"-"+kind+",");
                 response = socket.listener().trim();
                 socket.closeSocket();
                 System.out.println(response);
                 showFlights(company_);
                 AvailableFlightsMenu(company_);
            break;
            case 2:
                System.out.print("Flight number : ");
                flightNumber = scan.next();
                socket = new ResponseHandler();
                socket.writer("company-checkFlightNumber-"+company_+"-"+flightNumber+",");
                response = socket.listener().trim();
                socket.closeSocket();
                if(response.equals("valid")){
                    socket = new ResponseHandler();
                    socket.writer("company-deleteFlight-"+company_+"-"+flightNumber+",");
                    response = socket.listener().trim();
                    socket.closeSocket();
                    System.out.println(response);
                    showFlights(company_);
                    AvailableFlightsMenu(company_);
                }else{
                    System.out.println("There is no flight with that Flight number");
                    AvailableFlightsMenu(company_);
                }
            break;
            case 3:
            System.out.print("Flight number : ");
            flightNumber = scan.next();
            socket = new ResponseHandler();
            socket.writer("company-checkFlightNumber-"+company_+"-"+flightNumber+",");
            response = socket.listener().trim();
            socket.closeSocket();
            if(response.equals("valid")){
                socket = new ResponseHandler();
                socket.writer("company-deleteFlight-"+company_+"-"+flightNumber+",");
                response = socket.listener().trim();
                socket.closeSocket();
                System.out.print("new source : ");
                source = scan.next();
                System.out.print("new destination : ");
                destination = scan.next();
                System.out.print("new time : ");
                time = scan.next();
                System.out.print("new price : ");
                price = scan.next();
                System.out.print("new date(year/month/day) : ");
                date = scan.next();
                System.out.print("new Flight number : ");
                flightNumber = scan.next();
                System.out.print("new kind (international/domestic) : ");
                kind = scan.next();
                if(kind.equals("international")){
                kind = "int";
                }
                socket = new ResponseHandler();
                socket.writer("company-addFlight-"+company_+"-"+source+"-"+destination+"-"+time+"-"+price+"-"+date+"-"+flightNumber+"-"+kind+",");
                response = socket.listener().trim();
                socket.closeSocket();
                System.out.println("The Flight changed successfully.");
                showFlights(company_);
                AvailableFlightsMenu(company_);
            }else{
                System.out.println("There is no flight with that Flight number");
                AvailableFlightsMenu(company_);
            }
            break;
            case 4:
            showMenu(company_);
            break;
        }
    }

    static void seeSelloutTickets(String company_)throws IOException{
        ResponseHandler socket;
        socket = new ResponseHandler();
        socket.writer("company-SelloutTickets-"+company_+",");
        response = socket.listener().trim();
        socket.closeSocket();
        if(response.equals("invalid")){
        System.out.println("No Sellout FLights.");
        }else{
        System.out.println(response);
        }
        showMenu(company_);
    }

}

class ResponseHandler {
    Socket socket;
    DataInputStream dis;
    DataOutputStream dos;

    public ResponseHandler() throws IOException {
        this.socket = new Socket("192.168.1.11",2486);
        dis = new DataInputStream(socket.getInputStream());
        dos = new DataOutputStream(socket.getOutputStream());
    }

    String listener() {
        StringBuilder num = new StringBuilder();
        StringBuilder listen = new StringBuilder();
        char i;
        try {
            while ((i = (char) dis.read()) != ',') {
                listen.append(i);
            }
        } catch (IOException e) {
            try {
                dis.close();
                dos.close();
                socket.close();
            } catch (IOException ioException) {
                ioException.printStackTrace();
            }
            e.printStackTrace();
        }
        return listen.toString();
    }

    void writer(String write) {
        if (write != null && !write.isEmpty()) {
            try {
                dos.writeUTF(write);
                // System.out.println("write: " + write);
            } catch (IOException e) {
                try {
                    dis.close();
                    dos.close();
                    socket.close();
                } catch (IOException ioException) {
                    ioException.printStackTrace();
                }
                e.printStackTrace();
            }
            return;
        }
        // System.out.println("invalid write");
    }

    void closeSocket(){
        try {
            dis.close();
            dos.close();
            socket.close();
        } catch (IOException e) {
            e.printStackTrace();
        }
        // System.out.println("done");
    }
}
