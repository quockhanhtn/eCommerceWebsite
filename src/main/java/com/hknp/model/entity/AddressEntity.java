package com.hknp.model.entity;

import javax.persistence.*;
import java.io.Serializable;

@Entity
@Table(name = "ADDRESS")
public class AddressEntity implements Serializable {
   @Id
   @GeneratedValue(strategy = GenerationType.AUTO)
   @Column(name = "ADDRESS_ID")
   Long addressId;

   @Column(name = "STREET")
   String street;

   @ManyToOne(fetch = FetchType.EAGER)
   @JoinColumn(name = "COMMUNE_ID")
   CommuneEntity communeEntity;

   @ManyToOne(fetch = FetchType.EAGER)
   @JoinColumn(name = "DISTRICT_ID")
   DistrictEntity districtEntity;

   @ManyToOne(fetch = FetchType.EAGER)
   @JoinColumn(name = "PROVINCE_ID")
   ProvinceEntity provinceEntity;

   @Column(name = "USER_ID")
   Long userId;

   @Column(name = "FULL_NAME")
   String fullName;

   @Column(name = "ADDRESS_NAME")
   String addressName;

   @Column(name = "PHONE_NUMBER")
   String phoneNumber;


   public AddressEntity () {

   }

   public DistrictEntity getDistrictEntity() {
      return districtEntity;
   }

   public void setDistrictEntity(DistrictEntity districtEntity) {
      this.districtEntity = districtEntity;
   }

   public CommuneEntity getCommuneEntity() {
      return communeEntity;
   }

   public void setCommuneEntity(CommuneEntity communeEntity) {
      this.communeEntity = communeEntity;
   }

   public ProvinceEntity getProvinceEntity() {
      return provinceEntity;
   }

   public void setProvinceEntity(ProvinceEntity provinceEntity) {
      this.provinceEntity = provinceEntity;
   }

   public Long getAddressId() {
      return addressId;
   }

   public void setAddressId(Long addressId) {
      this.addressId = addressId;
   }

   public String getStreet() {
      return street;
   }

   public void setStreet(String street) {
      this.street = street;
   }

   public Long getUserId() {
      return userId;
   }

   public void setUserId(Long userId) {
      this.userId = userId;
   }

   public String getFullName() {
      return fullName;
   }

   public void setFullName(String fullName) {
      this.fullName = fullName;
   }

   public String getAddressName() {
      return addressName;
   }

   public void setAddressName(String addressName) {
      this.addressName = addressName;
   }

   public String getPhoneNumber() {
      return phoneNumber;
   }

   public void setPhoneNumber(String phoneNumber) {
      this.phoneNumber = phoneNumber;
   }
}