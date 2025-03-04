package com.example.backend.modules.products.entities;

import java.time.LocalDate;
import java.time.LocalDateTime;

import com.example.backend.modules.discounts.enitites.Discount;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.PrePersist;
import jakarta.persistence.PreUpdate;
import jakarta.persistence.Table;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Builder(toBuilder = true)
@NoArgsConstructor
@AllArgsConstructor
@Data
@Entity
@Table(name = "product_discounts")
public class ProductDiscount {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    // Liên kết tới Product
    @ManyToOne
    @JoinColumn(name = "product_id", nullable = false)
    private Product product;
    
    // Liên kết tới Discount (entity Discount đã được tạo)
    @ManyToOne
    @JoinColumn(name = "discount_id", nullable = false)
    private Discount discount;
    
    // Thông tin bổ sung (nếu cần): ví dụ, tỷ lệ giảm áp dụng riêng cho sản phẩm này
    private Double appliedDiscountRate;
    
    // Có thể thêm thời gian áp dụng cụ thể cho sản phẩm nếu cần
    private LocalDate startDate;
    private LocalDate endDate;

    @Column(name = "created_at", updatable = false)
    private LocalDateTime createdAt;
    
    @Column(name = "updated_at")
    private LocalDateTime updatedAt;
    
    @PrePersist
    protected void onCreate() {
        createdAt = LocalDateTime.now();
    }
    
    @PreUpdate
    protected void onUpdate() {
        updatedAt = LocalDateTime.now();
    }
}