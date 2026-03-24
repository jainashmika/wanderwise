package com.smarttravel.repository;

import com.smarttravel.model.ChatLog;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.List;

public interface ChatLogRepository extends JpaRepository<ChatLog, Integer> {

    List<ChatLog> findByUser_UserIdOrderByTimestampDesc(Integer userId);
}
