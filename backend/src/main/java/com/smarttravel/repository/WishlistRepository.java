package com.smarttravel.repository;

import com.smarttravel.model.Wishlist;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.List;

public interface WishlistRepository extends JpaRepository<Wishlist, Integer> {

    List<Wishlist> findByUser_UserId(Integer userId);
    void deleteByUser_UserIdAndHotel_HotelId(Integer userId, Integer hotelId);
}
