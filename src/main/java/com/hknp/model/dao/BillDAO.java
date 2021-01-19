package com.hknp.model.dao;

import com.hknp.interfaces.IModifySingleEntityAutoIncrement;
import com.hknp.interfaces.IRetrieveEntity;
import com.hknp.model.entity.BillDetailEntity;
import com.hknp.model.entity.BillEntity;
import com.hknp.utils.DateTimeUtils;
import com.hknp.utils.EntityUtils;
import com.hknp.utils.StringUtils;

import javax.persistence.*;
import java.math.BigInteger;
import java.util.ArrayList;
import java.util.Date;

public class BillDAO implements IRetrieveEntity<BillEntity, Long>, IModifySingleEntityAutoIncrement<BillEntity, Long> {
   private static BillDAO instance = null;

   private BillDAO() {
   }

   public static BillDAO getInstance() {
      if (instance == null) {
         instance = new BillDAO();
      }
      return instance;
   }

   @Override
   public Long insert(BillEntity entity) {
      Long newId = 0L;
      EntityManager entityMgr = EntityUtils.getEntityManager();
      EntityTransaction entityTrans = null;

      try {
         entityTrans = entityMgr.getTransaction();
         entityTrans.begin();

         entityMgr.persist(entity);
         newId = entity.getBillId();

         entityTrans.commit();
      } catch (Exception e) {
         if (entityTrans != null) {
            entityTrans.rollback();
         }
         e.printStackTrace();
      } finally {
         entityMgr.close();
      }

      return newId;
   }

   @Override
   public boolean update(BillEntity entity) {
      return EntityUtils.merge(entity);
   }

   @Override
   public boolean delete(Long id) {
      EntityManager entityMgr = EntityUtils.getEntityManager();
      EntityTransaction entityTrans = null;

      try {
         entityTrans = entityMgr.getTransaction();
         entityTrans.begin();

         BillEntity billEntity = entityMgr.find(BillEntity.class, id);
         entityMgr.remove(billEntity);

         entityTrans.commit();
      } catch (Exception e) {
         if (entityTrans != null) {
            entityTrans.rollback();
         }
         e.printStackTrace();
         entityMgr.close();
         return false;
      }
      return true;
   }

   @Override
   public ArrayList<BillEntity> gets() {
      return gets(null, null);
   }

   @Override
   public ArrayList<BillEntity> gets(Integer firstResult, Integer maxResults) {
      EntityManager entityMgr = EntityUtils.getEntityManager();

      String query = "SELECT u FROM BillEntity u";
      TypedQuery<BillEntity> typedQuery = entityMgr.createQuery(query, BillEntity.class);

      if (firstResult != null) {
         typedQuery.setFirstResult(firstResult);
      }
      if (maxResults != null) {
         typedQuery.setMaxResults(maxResults);
      }

      ArrayList<BillEntity> result = null;
      try {
         result = new ArrayList<>(typedQuery.getResultList());
      } catch (Exception exception) {
         exception.printStackTrace();
      } finally {
         entityMgr.close();
      }
      return result;
   }

   public ArrayList<BillEntity> gets(Integer firstResult, Integer maxResults, Integer status) {
      EntityManager entityMgr = EntityUtils.getEntityManager();

      String query = "SELECT u FROM BillEntity u where u.deliveryEntity.id = null and u.status = " + status;
      TypedQuery<BillEntity> typedQuery = entityMgr.createQuery(query, BillEntity.class);

      if (firstResult != null) {
         typedQuery.setFirstResult(firstResult);
      }
      if (maxResults != null) {
         typedQuery.setMaxResults(maxResults);
      }

      ArrayList<BillEntity> result = null;
      try {
         result = new ArrayList<>(typedQuery.getResultList());
      } catch (Exception exception) {
         exception.printStackTrace();
      } finally {
         entityMgr.close();
      }
      return result;
   }

   public ArrayList<BillEntity> getsForDelivery(Integer firstResult, Integer maxResults, Long deliveryId, Integer status) {
      EntityManager entityMgr = EntityUtils.getEntityManager();

      String strQuery = "SELECT u FROM BillEntity u where u.status = :status " +
              "and u.deliveryEntity.id = :deliveryId "  ;

      Query query = entityMgr.createQuery(strQuery);
      query.setParameter("deliveryId", deliveryId);
      query.setParameter("status", status);

      if (firstResult != null) {
         query.setFirstResult(firstResult);
      }
      if (maxResults != null) {
         query.setMaxResults(maxResults);
      }

      ArrayList<BillEntity> result = null;
      try {
         result = new ArrayList<>(query.getResultList());
      } catch (Exception exception) {
         exception.printStackTrace();
      } finally {
         entityMgr.close();
      }
      return result;
   }

   public ArrayList<BillEntity> getsForSeller(Integer firstResult, Integer maxResults, Long sellerId, Integer status) {
      EntityManager entityMgr = EntityUtils.getEntityManager();

      String strQuery = "SELECT distinct u.billEntity FROM BillDetailEntity AS u " +
              "WHERE u.productTypeEntity.productEntity.sellerEntity.userId = :sellerId " +
              "and u.billEntity.status = :status ";

      Query query = entityMgr.createQuery(strQuery);
      query.setParameter("sellerId", sellerId);
      query.setParameter("status", status);

      if (firstResult != null) {
         query.setFirstResult(firstResult);
      }
      if (maxResults != null) {
         query.setMaxResults(maxResults);
      }

      ArrayList<BillEntity> result = null;
      try {
         result = new ArrayList<>(query.getResultList());
      } catch (Exception exception) {
         exception.printStackTrace();
      } finally {
         entityMgr.close();
      }
      return result;
   }

   public ArrayList<BillEntity> getsByMonth(String first, String last) {
      EntityManager entityMgr = EntityUtils.getEntityManager();
      String strQuery = null;
      if(first != "12"){
         strQuery = "SELECT u FROM BillEntity AS u where u.billCreateDate between '2021-" +first + "-01' and '2021-" +last +"-01' ";
      }
      else{
         strQuery = "SELECT u FROM BillEntity AS u where u.billCreateDate between '2021-" +first + "-01' and '2021-" +first +"-31' ";
      }

      Query query = entityMgr.createQuery(strQuery);

      ArrayList<BillEntity> result = null;
      try {
         result = new ArrayList<>(query.getResultList());
      } catch (Exception exception) {
         exception.printStackTrace();
      } finally {
         entityMgr.close();
      }
      return result;
   }

   public  ArrayList<BillEntity> getsForSumByMonth(String first, String last , Long sellerId){
      EntityManager entityMgr = EntityUtils.getEntityManager();

      String strQuery = "SELECT distinct u.billEntity FROM BillDetailEntity AS u " +
              "WHERE u.productTypeEntity.productEntity.sellerEntity.userId = :sellerId " +
              "and u.billEntity.status = 6 " +
              "and u.billEntity.billCreateDate between '2021-"+first+"-01' and '2021-"+last+"-01' ";

      Query query = entityMgr.createQuery(strQuery);
      query.setParameter("sellerId", sellerId);

      ArrayList<BillEntity> result = null;
      try {
         result = new ArrayList<>(query.getResultList());
      } catch (Exception exception) {
         exception.printStackTrace();
      } finally {
         entityMgr.close();
      }
      return result;
   }

   @Override
   public BillEntity getById(Long id) {
      EntityManager entityMgr = EntityUtils.getEntityManager();
      return entityMgr.find(BillEntity.class, id);
   }

   @Override
   public Long count() {return EntityUtils.count(BillEntity.class.getName());}

   public Long count(Long sellerId, Integer status){
      EntityManager entityMgr = EntityUtils.getEntityManager();

      String queryStr;
      Query query;
      queryStr = "SELECT distinct u.billEntity FROM BillDetailEntity AS u " +
              "WHERE u.productTypeEntity.productEntity.sellerEntity.userId = :sellerId " +
              "and u.billEntity.status = :status";
      query = entityMgr.createQuery(queryStr);
      query.setParameter("sellerId", sellerId);
      query.setParameter("status", status);
      ArrayList<BillEntity> result = null;
      result = new ArrayList<>(query.getResultList());
      return (Long) result.stream().count();
   }

   public Long countForShipper(Long deliveryId, Integer status){
      EntityManager entityMgr = EntityUtils.getEntityManager();

      String queryStr;
      Query query;
      queryStr = "SELECT count(b.billId) from  BillEntity b " +
              "WHERE b.deliveryEntity.userId = :deliveryId " +
              "and b.status = :status";
      query = entityMgr.createQuery(queryStr);
      query.setParameter("deliveryId", deliveryId);
      query.setParameter("status", status);
      return (Long) query.getSingleResult();
   }

   public Long count(Integer status){
      EntityManager entityMgr = EntityUtils.getEntityManager();

      String queryStr;
      Query query;
      queryStr = "SELECT count(*) from  BillEntity b WHERE b.status = :status";
      query = entityMgr.createQuery(queryStr);
      query.setParameter("status", status);
      return (Long) query.getSingleResult();
   }

   public  Long CountCustomerForSeller(Long sellerId){
      EntityManager entityMgr = EntityUtils.getEntityManager();
      String strQuery ="select  distinct b.billEntity.customerEntity from BillDetailEntity AS b " +
              "where  b.productTypeEntity.productEntity.sellerEntity.userId = :sellerId ";
      Query query = entityMgr.createQuery(strQuery);
      query.setParameter("sellerId", sellerId);
      ArrayList<BillEntity> result = null;
      try {
         result = new ArrayList<>(query.getResultList());
      } catch (Exception exception) {
         exception.printStackTrace();
      } finally {
         entityMgr.close();
      }
      return result.stream().count();
   }
}