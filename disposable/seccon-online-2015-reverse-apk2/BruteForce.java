/* This code is only for SECCON 2015 online quize.
*  https://github.com/SECCON/SECCON2015_online_CTF/tree/master/Unknown/400_Reverse-Engineering%20Android%20APK%202%E2%80%99%0A
*
*  Environment:
*  * Java version over 7
*
*  Usage:
*  * javac BruteForce.java
*  * java BruteForce
*/

import java.io.PrintStream;
import javax.crypto.Cipher;
import javax.crypto.spec.SecretKeySpec;

class BruteForce {

	static final char[] candidates = "0123456789abcdef".toCharArray();
	static final int candLength = candidates.length;

	public static void main(String args[]){
		System.out.println("candidates" + candidates);
		int count = 0;

		double[] powers = new double[16];
		for (int i = 0; i < 16; i ++) {
			powers[i] = Math.pow(candLength, i+1);
		}
		int[] indexes = new int[16];
		while (true) {
			String uid = "";
			for (int i = 0; i < 16; i ++) {
				indexes[i] = ((count) / (int)powers[i]) % candLength;
				uid += candidates[indexes[i]];
			}
			System.out.println(count + ": uid: " + uid);
			byte[] stream = tryData(uid);
			if (stream != null) {
				try {
					String flag = new String(stream, "UTF-8");
					System.out.println("flag = " + flag);
					if(flag.startsWith("SECCON{")) {
						System.out.println("flag = " + flag);
						break;
					}
				} catch (Exception e) {
					System.out.println("Cannot convert to string!");
				}
			}
			count ++;
		}
		return;
	}

	public static final byte[] tryData(String uid) {
		String strKey = "fuO/gyps1L1JZwet4jYaU0hNvIxa/ncffqy+3fEHIn4=";
		byte[] flag = null;
		try
		{
			SecretKeySpec key = new SecretKeySpec(uid.getBytes(), "AES");
			Cipher cipher = Cipher.getInstance("AES/ECB/PKCS5Padding");
			cipher.init(2, key);
			byte[] stream = function(strKey.getBytes());
			flag = cipher.doFinal(stream);
		}
		catch(Throwable e)
		{
			System.out.println("error" + e);
		}
		return flag;
	}

	public static final byte[] function(byte abyte0[])
	{
			int j = 0;
			int i;
			for(i = abyte0.length; abyte0[i - 1] == 61; i--);
			byte abyte1[] = new byte[i - abyte0.length / 4];
			i = 0;
			while(i < abyte0.length)
			{
					if(abyte0[i] == 61)
							abyte0[i] = 0;
					else
					if(abyte0[i] == 47)
							abyte0[i] = 63;
					else
					if(abyte0[i] == 43)
							abyte0[i] = 62;
					else
					if(abyte0[i] >= 48 && abyte0[i] <= 57)
							abyte0[i] = (byte)(abyte0[i] + 4);
					else
					if(abyte0[i] >= 97 && abyte0[i] <= 122)
							abyte0[i] = (byte)(abyte0[i] - 71);
					else
					if(abyte0[i] >= 65 && abyte0[i] <= 90)
							abyte0[i] = (byte)(abyte0[i] - 65);
					i++;
			}
			i = 0;
			for(; j < abyte1.length - 2; j += 3)
			{
					abyte1[j] = (byte)(abyte0[i] << 2 & 0xff | abyte0[i + 1] >>> 4 & 3);
					abyte1[j + 1] = (byte)(abyte0[i + 1] << 4 & 0xff | abyte0[i + 2] >>> 2 & 0xf);
					abyte1[j + 2] = (byte)(abyte0[i + 2] << 6 & 0xff | abyte0[i + 3] & 0x3f);
					i += 4;
			}

			if(j < abyte1.length)
					abyte1[j] = (byte)(abyte0[i] << 2 & 0xff | abyte0[i + 1] >>> 4 & 3);
			j++;
			if(j < abyte1.length)
			{
					byte byte0 = abyte0[i + 1];
					abyte1[j] = (byte)(abyte0[i + 2] >>> 2 & 0xf | byte0 << 4 & 0xff);
			}
			return abyte1;
	}
}
