import java.io.*;
import java.util.HashMap;
public class DataBase {

    static int companyCounter = 0;
    static int clientCounter = 0;
    private final HashMap<String, Controller> dataBase = new HashMap<>();
    static private DataBase instance;

    static public DataBase getInstance() {
        if (instance == null) {
            instance = new DataBase();
        }
        return instance;
    }

    void addDataBase(String str, Controller controller) {
        dataBase.put(str, controller);
    }

    Controller getController(String str) {
        return dataBase.get(str);
    }
}

class Controller {
    private final File file;
    private RandomAccessFile raf;
    private FileWriter fw;

    public Controller(String str) {
        file = new File(str);
        try {
            raf = new RandomAccessFile(file, "rw");
            String last = readFile();
            fw = new FileWriter(file);
            writeFile(last);
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    String readFile() {
        StringBuilder recovery = new StringBuilder();
        String i;
        try {
            while ((i = raf.readLine()) != null) {
                recovery.append(i).append("\n");
            }
            raf.seek(0);
        } catch (IOException e) {
            e.printStackTrace();
        }
        return recovery.toString();
    }

    void writeFile(String str, boolean... reset) {
        try {
            if (reset.length != 0) {
                fw = new FileWriter(file);
            }
            fw.write(str);
            fw.flush();
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    String getRow(String id) {
        String[] split = this.readFile().split("\n");
        for (String str : split) {
            if (str.startsWith(id)) {
                return str;
            }
        }
        return "invalid";
    }

    String getRows(String id,int splitNum) {
        String[] split = this.readFile().split("\n");
        String result="";
        for (String str : split) {
            if(!(str.equals(""))){
            if (str.split("-")[splitNum].equals(id)) {
                result += str;
                result += "\n";
            }
        }
        }
        if(result.equals("")){
            return "invalid";
        }else {
            return result;
        }
    }

    String getRows(String id,int splitNum,String id2,int splitNum2) {
        String[] split = this.readFile().split("\n");
        String result="";
        for (String str : split) {
            if(!(str.equals(""))){
            if (str.split("-")[splitNum].equals(id) && str.split("-")[splitNum2].equals(id2)) {
                result += str;
                result += "\n";
            }
        }
        }
        if(result.equals("")){
            return "invalid";
        }else {
            return result;
        }
    }

    String getRows(String id,int splitNum,String id2,int splitNum2,String id3,int splitNum3) {
        String[] split = this.readFile().split("\n");
        String result="";
        for (String str : split) {
            if(!(str.equals(""))){
            if (str.split("-")[splitNum].equals(id) && str.split("-")[splitNum2].equals(id2) && str.split("-")[splitNum3].equals(id3)) {
                result += str;
                result += "\n";
            }
        }
        }
        if(result.equals("")){
            return "invalid";
        }else {
            return result;
        }
    }

    void removeId(String id) {

    }
}