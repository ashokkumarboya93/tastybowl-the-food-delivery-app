package com.food.model;

import java.sql.Timestamp;

public class User {

    private int userid;
    private String username;
    private String password;
    private String email;
    private String phone;
    private String address;
    private String city;
    private String state;
    private String pincode;
    private Timestamp createDate;
    private Timestamp lastLogin;
    private String role;

    public User() {
    }

    // Constructor with original fields
    public User(int userid, String username, String password, String email,
                String address, Timestamp createDate,
                Timestamp lastLogin, String role) {

        this.userid = userid;
        this.username = username;
        this.password = password;
        this.email = email;
        this.address = address;
        this.createDate = createDate;
        this.lastLogin = lastLogin;
        this.role = role;
    }

    // Constructor with all fields
    public User(int userid, String username, String password, String email,
                String phone, String address, String city, String state, String pincode,
                Timestamp createDate, Timestamp lastLogin, String role) {
        this.userid = userid;
        this.username = username;
        this.password = password;
        this.email = email;
        this.phone = phone;
        this.address = address;
        this.city = city;
        this.state = state;
        this.pincode = pincode;
        this.createDate = createDate;
        this.lastLogin = lastLogin;
        this.role = role;
    }

    public int getUserid() {
        return userid;
    }

    public void setUserid(int userid) {
        this.userid = userid;
    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
    }

    public String getCity() {
        return city;
    }

    public void setCity(String city) {
        this.city = city;
    }

    public String getState() {
        return state;
    }

    public void setState(String state) {
        this.state = state;
    }

    public String getPincode() {
        return pincode;
    }

    public void setPincode(String pincode) {
        this.pincode = pincode;
    }

    public Timestamp getCreateDate() {
        return createDate;
    }

    public void setCreateDate(Timestamp createDate) {
        this.createDate = createDate;
    }

    public Timestamp getLastLogin() {
        return lastLogin;
    }

    public void setLastLogin(Timestamp lastLogin) {
        this.lastLogin = lastLogin;
    }

    public String getRole() {
        return role;
    }

    public void setRole(String role) {
        this.role = role;
    }

    @Override
    public String toString() {
        return "User [userid=" + userid + ", username=" + username +
                ", password=" + password + ", email=" + email +
                ", phone=" + phone + ", address=" + address +
                ", city=" + city + ", state=" + state + ", pincode=" + pincode +
                ", createDate=" + createDate + ", lastLogin=" + lastLogin +
                ", role=" + role + "]";
    }
}