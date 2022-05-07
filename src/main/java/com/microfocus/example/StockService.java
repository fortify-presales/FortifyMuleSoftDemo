package com.microfocus.example;

import java.util.Random;
import java.util.UUID;

public class StockService {

	private final static int MAX_STOCK_LEVEL = 1000;
	
	public StockService() {
		
	}
	
	public static int getStockLevel(String productId) {
	    System.out.println("Product id: " + productId);
		Random rand = new Random(); //instance of random class
	    int stock_level = rand.nextInt(MAX_STOCK_LEVEL);
	    System.out.println("Stock level: " + stock_level);
	    return stock_level;
	}
	
	public int getStockLevelData(String productId) {
	    System.out.println("Product id: " + productId);
		Random rand = new Random(); //instance of random class
	    int stock_level = rand.nextInt(MAX_STOCK_LEVEL);
	    System.out.println("Stock level: " + stock_level);
	    return stock_level;
	}
	
	public static void main(String[] a) {
		System.out.println(StockService.getStockLevel(UUID.randomUUID().toString()));
		StockService sService = new StockService();
		System.out.println(sService.getStockLevelData(UUID.randomUUID().toString()));
	}
}
