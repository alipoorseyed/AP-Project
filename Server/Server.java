import java.io.*;
import java.net.ServerSocket;
import java.net.Socket;

public class Server {
    public static void main(String[] args) {
        try {
            ServerSocket serverSocket = new ServerSocket(2486);

            DataBase.getInstance().addDataBase("UsersBasicInfo", new Controller("/home/khb/github/server/data/UsersBasicInfo.txt"));
            DataBase.getInstance().addDataBase("Flights", new Controller("/home/khb/github/server/data/Flights.txt"));
            DataBase.getInstance().addDataBase("Budget", new Controller("/home/khb/github/server/data/Budget.txt"));
            DataBase.getInstance().addDataBase("BuyedFlights", new Controller("/home/khb/github/server/data/BuyedFlights.txt"));
            DataBase.getInstance().addDataBase("Transactions", new Controller("/home/khb/github/server/data/Transactions.txt"));
            DataBase.getInstance().addDataBase("DiscountCodes", new Controller("/home/khb/github/server/data/DiscountCodes.txt"));
            DataBase.getInstance().addDataBase("UsersInfo", new Controller("/home/khb/github/server/data/UsersInfo.txt"));
            DataBase.getInstance().addDataBase("CompaniesBasicInfo", new Controller("/home/khb/github/server/data/CompaniesBasicInfo.txt"));
            DataBase.getInstance().addDataBase("Companies", new Controller("/home/khb/github/server/data/Companies.txt"));

            while (true) {
                Socket socket = serverSocket.accept();
                System.out.println("Connected...");
                RequestHandler requestHandler = new RequestHandler(socket);
                requestHandler.start();
            }
        } catch (IOException e) {
            e.printStackTrace();
        }
    }
} 

class RequestHandler extends Thread {
    Socket socket;
    DataInputStream dis;
    DataOutputStream dos;

    public RequestHandler(Socket socket) throws IOException {
        this.socket = socket;
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
        }
        return listen.toString();
    }

    void writer(String write) {
        if (write != null && !write.isEmpty()) {
            try {
                dos.writeUTF(write);
                System.out.println("write: " + write);
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
        System.out.println("invalid write");
    }

    @Override
    public void run() {
        System.out.println("ready");
        String command = listener();
        command = command.trim();
        if(command.substring(1).startsWith("company")){
            command = command.substring(1);
        }
        if(command.substring(2).startsWith("company")){
            command = command.substring(2);
        }
        System.out.println("command is: " + command);
        String[] split = command.split("-");

        if (split[0].equals("client")){
            String data = "";
            ClientAccount clientAccount;
            Flights flights;
            Accounting accounting;

            switch(split[1]){

                case "signup":
                data = split[2]+"-"+split[3]+"-"+split[4];
                clientAccount = new ClientAccount(data);
                writer(clientAccount.signUp());
                break;

                case "verifyLogin":
                data = split[2]+"-"+split[3];
                clientAccount = new ClientAccount(data);
                writer(clientAccount.Login());
                break;

                case "flightresult":
                data = split[3]+"-"+split[4]+"-"+split[5];
                flights = new Flights(data);
                writer(flights.FlightSearchResult());
                break;

                case "budget":
                data = split[2];
                accounting = new Accounting(data);
                writer(accounting.getBudget());
                break;

                case "buyFlight":
                data = split[2]+"-"+split[3]+"-"+split[4]+"-"+split[5];
                flights = new Flights(data);
                writer(flights.buyFlight());
                break;

                case "FlightBookingDomestic":
                flights = new Flights("");
                writer(flights.FlightBookingDomestic());
                break;

                case "FlightBookingInt":
                flights = new Flights("");
                writer(flights.FlightBookingInt());
                break;

                case "Discount":
                data = split[2];
                accounting = new Accounting(data);
                writer(accounting.CheckDiscount());
                break;

                case "AccountInfo":
                data = split[2];
                clientAccount = new ClientAccount(data);
                writer(clientAccount.GetInfo());
                break;

                case "changePassword":
                data = split[2]+"-"+split[3];
                clientAccount = new ClientAccount(data.split("-")[0]);
                writer(clientAccount.changePassword(data.split("-")[1]));
                break;

                case "changeEmail":
                data = split[2]+"-"+split[3];
                clientAccount = new ClientAccount(data.split("-")[0]);
                writer(clientAccount.changeEmail(data.split("-")[1]));
                break;

                case "changeInfo":
                data = split[2]+"-"+split[3]+"-"+split[4]+"-"+split[5]+"-"+split[6];
                clientAccount = new ClientAccount(data);
                writer(clientAccount.changeInfo());
                break;

                case "increaseBudget":
                data = split[2];
                accounting = new Accounting(data);
                writer(accounting.increaseBudget(split[3],split[4]));
                break;

                case "moneyPage":
                data = split[2];
                accounting = new Accounting(data);
                writer(accounting.MoneyPage());
                break;

                case "getUserFlights":
                data = split[2];
                flights = new Flights(data);
                writer(flights.getUserFlights());
                break;

            }

        }else if (split[0].equals("company")){
            String data = "";
            CompanyAccount companyAccount;
            ClientAccount clientAccount;
            Flights flights;
            Accounting accounting;

            switch(split[1]){
                
                case "checkUsername":
                data = split[2];
                companyAccount = new CompanyAccount(data);
                writer(companyAccount.checkUsername()+",");
                break;

                case "checkCompany":
                data = split[2];
                companyAccount = new CompanyAccount(data);
                writer(companyAccount.checkCompany()+",");
                break;

                case "signup":
                data = split[2]+"-"+split[3]+"-"+split[4];
                companyAccount = new CompanyAccount(data);
                writer(companyAccount.signUp()+",");
                break;

                case "Login":
                data = split[2]+"-"+split[3];
                companyAccount = new CompanyAccount(data);
                writer(companyAccount.Login()+",");
                break;

                case "AvailableFlights":
                data = split[2];
                companyAccount = new CompanyAccount(data);
                writer(companyAccount.GetAvailableFlights()+",");
                break;            

                case "addFlight":
                data = split[2]+"-"+split[3]+"-"+split[4]+"-"+split[5]+"-"+split[6]+"-"+split[7]+"-"+split[8]+"-"+split[9];
                flights = new Flights(data);
                writer(flights.addFlight()+",");
                break;

                case "checkFlightNumber":
                data = split[2]+"-"+split[3];
                flights = new Flights(data);
                writer(flights.checkFlightNumber()+",");
                break;

                case "deleteFlight":
                data = split[2]+"-"+split[3];
                flights = new Flights(data);
                writer(flights.deleteFlight()+",");
                break;

                case "SelloutTickets":
                data = split[2];
                flights = new Flights(data);
                writer(flights.SelloutTickets()+",");
                break;

                case "mostSelledTicket":
                data = split[2];
                flights = new Flights(data);
                writer(flights.mostSelledTicket()+",");
                break;

                case "getAverageEarnings":
                data = split[2];
                flights = new Flights(data);
                writer(flights.calculateAverageEarnings(split[3])+",");
                break;

                case "getCompany":
                data = split[2];
                companyAccount = new CompanyAccount(data);
                writer(companyAccount.getCompany()+",");
                break;     
            }
        }

        try {
            dis.close();
            dos.close();
            socket.close();
        } catch (IOException e) {
            e.printStackTrace();
        }
        System.out.println("done");
    }
}