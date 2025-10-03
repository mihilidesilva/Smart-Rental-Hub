package com.smart.rentalhub.model;

import java.sql.Timestamp;

public class CommunityComment {
    private int id;
    private int postId;
    private String username;
    private String comment;
    private Timestamp createdAt;

    public int getId() {
        return id; 
    }
    public void setId(int id) {
        this.id = id; 
    }
    public int getPostId() { 
        return postId; 
    }
    public void setPostId(int postId) {
        this.postId = postId; 
    }
    public String getUsername() {
        return username; 
    }
    public void setUsername(String username) {
        this.username = username; 
    }
    public String getComment() { 
        return comment; 
    }
    public void setComment(String comment) {
        this.comment = comment; 
    }
    public Timestamp getCreatedAt() {
        return createdAt; 
    }
    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }
}