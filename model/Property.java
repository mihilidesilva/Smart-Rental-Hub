package com.smart.rentalhub.model;

import java.sql.Timestamp;

public class Property {
    private int id;
    private int landlord_id;
    private String title;
    private String description;
    private String city;
    private double price;
    private String property_type;
    private String image;
    private boolean availability;
    private Timestamp createdAt; 


    
    public int getId() {
        return id;
    }
    public void setId(int id) {
        this.id = id;
    }


    public int getLandlord_id() {
        return landlord_id;
    }
    public void setLandlord_id(int landlord_id) {
        this.landlord_id = landlord_id;
    }

  
    public String getTitle() {
        return title;
    }
    public void setTitle(String title) {
        this.title = title;
    }

    public String getDescription() {
        return description;
    }
    public void setDescription(String description) {
        this.description = description;
    }

    public String getCity() {
        return city;
    }
    public void setCity(String city) {
        this.city = city;
    }

   
    public double getPrice() {
        return price;
    }
    public void setPrice(double price) {
        this.price = price;
    }


    public String getProperty_type() {
        return property_type;
    }
    public void setProperty_type(String property_type) {
        this.property_type = property_type;
    }

    public String getImage() {
        return image;
    }
    public void setImage(String image) {
        this.image = image;
    }

   
    public boolean isAvailability() {
        return availability;
    }
    public void setAvailability(boolean availability) {
        this.availability = availability;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }
}
