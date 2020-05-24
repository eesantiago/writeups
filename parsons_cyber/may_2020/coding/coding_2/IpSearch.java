//Version 1.8.0_101
import java.util.Scanner;
import java.util.Arrays;

import java.io.File;
import java.io.FileNotFoundException;

public class IpSearch
{
  public static void main(String[] args) 
  {
    if(args.length != 1)
    {
      System.out.println("ip required");
      System.exit(0);
    }

    String ip = args[0];
    Scanner scanner = new Scanner(System.in);
    System.out.println("Please enter the filepath: ");
    String path = scanner.next();        
    try {
          inBlock(ip, path);
        }
        catch (FileNotFoundException e) {
          System.out.println("File not found, please check to make sure file exists");
        }
  }
  public static void inBlock(String ipToCheck, String filepath) throws FileNotFoundException 
  {
    try 
    {
      Scanner scanner = new Scanner(new File(filepath));
      String block;
      String lowip, highip;
      long low, high, ipNum;
      while (scanner.hasNext()) 
      {
          block = scanner.nextLine();
          String ip, ipCheck;
          if (block.contains(" - ")) 
          {
            String newBlock = block.replace(" - ", "/");
            String[] parts = new String[4];
            parts = newBlock.split("/");
            lowip = parts[0];
            highip = parts[2];
            ip = parts[2];
            long mask = calcMask(parts[1]);
            low = (ipToInteger(lowip)) & mask;
            high = ipToInteger(highip) & mask;
            ipNum = ipToInteger(ipToCheck) & mask;
            if(ipNum < low && ipNum > high)
            {
              System.out.println(block.substring(3,9));
              System.exit(0);
            }
          } 
          else 
          {
            String[] parts = new String[2];
            parts = block.split("/");
            ip = ipToBinary(parts[0]);
            int size = Integer.parseInt(parts[1]);
            ipCheck = ipToBinary(ipToCheck);
            if (ip.regionMatches(0, ipCheck, 0, size)) 
            {
              System.out.println(block.substring(2,5));
              System.exit(0);
            }
          }
      }
      System.out.println("not found");
    }
    catch (FileNotFoundException ex) {
      System.out.println("File not found, please check to make sure file exists");
    }
  }

  public static String ipToBinary(String ip) 
  {
    int len = ip.length();
    int addr = 0;
    int totalAddr = 0;
    char [] bin = new char[32];

    for (int i = 0; i < len; i++) 
    {
      char digit = ip.charAt(i);
      if (digit != '.') 
      {
        addr = addr * 10 + (digit - '0');
      }
      else 
      {
        totalAddr = (totalAddr << 8) | addr;
        addr = 0;
      }
    }
    totalAddr = (totalAddr << 8) | addr;
    for (int u = 0; u < 32; u++, totalAddr <<= 1) 
    {
      bin[u] = ((totalAddr & 0x80000000) != 0) ? '1' : '0';
    }
    return new String(bin);
  }

  public static long ipToInteger(String ip)
  {
    int[] ipArray = new int[4];
    long res = 0;
    String[] ipParts = ip.split("\\.");
    for(int i = 0; i < 4; i++)
    {
      ipArray[i] = Integer.parseInt(ipParts[i]);
    }
    for(int i = 0; i < 4; i++)
    {
      res += ipArray[i] << (24 - (8 * i));
    }
    return res;
  }

  public static long calcMask(String preSize)
  {
    int prefix = 0;
    prefix = Integer.parseInt(preSize);
    long mask = 0xFFFFFFFF << (32 - prefix);
    return mask;
  }
}
