package com.smarttravel.model;

import jakarta.persistence.AttributeConverter;
import jakarta.persistence.Converter;

@Converter(autoApply = true)
public class PaymentMethodConverter implements AttributeConverter<Payment.PaymentMethod, String> {

    @Override
    public String convertToDatabaseColumn(Payment.PaymentMethod attribute) {
        if (attribute == null) return null;
        switch (attribute) {
            case Credit_Card:
                return "Credit Card";
            case Debit_Card:
                return "Debit Card";
            case Net_Banking:
                return "Net Banking";
            case UPI:
                return "UPI";
            default:
                return attribute.name();
        }
    }

    @Override
    public Payment.PaymentMethod convertToEntityAttribute(String dbData) {
        if (dbData == null || dbData.trim().isEmpty()) return null;
        String clean = dbData.trim();
        if ("Credit Card".equalsIgnoreCase(clean) || "Credit_Card".equalsIgnoreCase(clean)) {
            return Payment.PaymentMethod.Credit_Card;
        } else if ("Debit Card".equalsIgnoreCase(clean) || "Debit_Card".equalsIgnoreCase(clean)) {
            return Payment.PaymentMethod.Debit_Card;
        } else if ("Net Banking".equalsIgnoreCase(clean) || "Net_Banking".equalsIgnoreCase(clean)) {
            return Payment.PaymentMethod.Net_Banking;
        } else if ("UPI".equalsIgnoreCase(clean)) {
            return Payment.PaymentMethod.UPI;
        }
        try {
            return Payment.PaymentMethod.valueOf(clean);
        } catch (IllegalArgumentException e) {
            return null;
        }
    }
}
