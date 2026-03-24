package com.smarttravel.service;

import com.smarttravel.model.*;
import com.smarttravel.repository.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.List;
import java.util.Optional;

@Service
public class BookingService {

    @Autowired private BookingRepository bookingRepository;
    @Autowired private UserRepository userRepository;
    @Autowired private HotelRepository hotelRepository;
    @Autowired private TransportRepository transportRepository;
    @Autowired private BudgetPackageRepository packageRepository;

    // ---------- CREATE BOOKING ----------
    // @Transactional: if anything fails, the whole operation rolls back (ACID)
    @Transactional
    public String createBooking(Integer userId, Integer hotelId, Integer transportId,
                                Integer packageId, LocalDate checkIn, LocalDate checkOut,
                                Integer numPeople) {

        Optional<User> userOpt = userRepository.findById(userId);
        if (userOpt.isEmpty()) return "USER_NOT_FOUND";

        Booking booking = new Booking();
        booking.setUser(userOpt.get());
        booking.setCheckInDate(checkIn);
        booking.setCheckOutDate(checkOut);
        booking.setNumPeople(numPeople);

        BigDecimal total = BigDecimal.ZERO;

        // Attach hotel if provided
        if (hotelId != null) {
            Optional<Hotel> hotelOpt = hotelRepository.findById(hotelId);
            if (hotelOpt.isPresent()) {
                Hotel hotel = hotelOpt.get();
                booking.setHotel(hotel);
                // Calculate hotel cost: price_per_night x number of nights
                long nights = checkOut.toEpochDay() - checkIn.toEpochDay();
                total = total.add(hotel.getPricePerNight().multiply(BigDecimal.valueOf(nights)));
            }
        }

        // Attach transport if provided
        if (transportId != null) {
            Optional<Transport> transportOpt = transportRepository.findById(transportId);
            transportOpt.ifPresent(t -> {
                booking.setTransport(t);
            });
            if (transportOpt.isPresent()) {
                total = total.add(transportOpt.get().getFare().multiply(BigDecimal.valueOf(numPeople)));
            }
        }

        // Attach package if provided
        if (packageId != null) {
            Optional<BudgetPackage> pkgOpt = packageRepository.findById(packageId);
            pkgOpt.ifPresent(booking::setBudgetPackage);
            if (pkgOpt.isPresent()) {
                total = total.add(pkgOpt.get().getTotalCost());
            }
        }

        booking.setTotalAmount(total);
        bookingRepository.save(booking);
        return "BOOKING_CONFIRMED";
    }

    // ---------- GET BOOKINGS FOR USER ----------
    public List<Booking> getBookingsByUser(Integer userId) {
        return bookingRepository.findByUser_UserId(userId);
    }

    // ---------- CANCEL BOOKING ----------
    @Transactional
    public String cancelBooking(Integer bookingId) {
        Optional<Booking> bookingOpt = bookingRepository.findById(bookingId);
        if (bookingOpt.isEmpty()) return "BOOKING_NOT_FOUND";

        Booking booking = bookingOpt.get();
        booking.setStatus(Booking.BookingStatus.Cancelled);
        bookingRepository.save(booking);
        return "CANCELLED";
    }

    // ---------- REPORTS ----------
    public BigDecimal getTotalRevenue() {
        return bookingRepository.getTotalRevenue();
    }

    public List<Object[]> getMostPopularHotels() {
        return bookingRepository.getMostPopularHotels();
    }
}
