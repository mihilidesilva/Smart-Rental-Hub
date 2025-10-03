package com.smart.rentalhub.model;

public class PrivacySettings {
    private int userId;
    private boolean profileVisible;
  
    public PrivacySettings() {}
    public PrivacySettings(int userId, boolean profileVisible) {
        this.userId = userId;
        this.profileVisible = profileVisible;
//        this.allowMessages = allowMessages;
//        this.showActivity = showActivity;
    }

    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }

    public boolean isProfileVisible() { return profileVisible; }
    public void setProfileVisible(boolean profileVisible) { this.profileVisible = profileVisible; }
//
//    public boolean isAllowMessages() { return allowMessages; }
//    public void setAllowMessages(boolean allowMessages) { this.allowMessages = allowMessages; }
//
//    public boolean isShowActivity() { return showActivity; }
//    public void setShowActivity(boolean showActivity) { this.showActivity = showActivity; }
}
