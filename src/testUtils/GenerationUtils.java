package testUtils;

import java.util.ArrayList;

/**
 * Created by Alex on 26/05/2017.
 */
public class GenerationUtils {
	private static ArrayList<String> generatedStrings = new ArrayList<>();
	private static ArrayList<Integer> generatedIntegers = new ArrayList<>();
	
	public static String generateRandomString(int length){
		String generatedString = "";
		for (int i = 0; i < length; i++) {
			int keycode = generateRandomInt(26)+65;
			char generatedChar = (char) keycode;
			if (generateRandomInt(2)==0){
				generatedChar = Character.toLowerCase(generatedChar);
			}
			generatedString += generatedChar;
		}
		return generatedString;
	}
	
	public static String generateUniqueString(int length){
		String generatedString = generateRandomString(length);
		for (int i = 0; i < 1_000_000; i++) {
			if (!generatedStrings.contains(generatedString)) {
				generatedStrings.add(generatedString);
				return generatedString;
			}
			generatedString = generateRandomString(length);
		}
		throw new IllegalStateException("No unique string could be generated");
	}
	
	public static int generateRandomInt(int nonIncludedMaximum){
		return (int) (Math.random()*nonIncludedMaximum);
	}
	
	public static int generateRandomIntByLength(int length){
		if (length>9){
			throw new IllegalArgumentException("Length of an integer cannot be greater than 9");
		}
		int[] generatedInt = new int[length];
		generatedInt[0] = generateRandomInt(9)+1;
		for (int i = 1; i < length; i++) {
			generatedInt[i] = generateRandomInt(10);
		}
		String appender = "";
		for (int i = 0; i < generatedInt.length; i++) {
			appender += generatedInt[i];
		}
		return Integer.valueOf(appender);
	}
	
	public static int generateUniqueInt(int nonIncludedMaximum){
		int nonUniqueRandom = generateRandomInt(nonIncludedMaximum);
		for (int i = 0; i < 1_000_000; i++) {
			if (!generatedIntegers.contains(nonUniqueRandom)) {
				generatedIntegers.add(nonUniqueRandom);
				return nonUniqueRandom;
			}
			nonUniqueRandom = generateRandomInt(nonIncludedMaximum);
		}
		throw new IllegalStateException("No unique inger could be generated");
	}
	
	public static void main(String args[]){
		
	}
}
