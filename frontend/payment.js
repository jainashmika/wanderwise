/* ============================================================
   WanderWise Payment System
   Handles secure payment processing and validation
   ============================================================ */

(function () {
  'use strict';

  const API_BASE = (window.location.protocol.startsWith('http') ? window.location.origin : 'http://localhost:8085') + '/api';
  const CURRENCY = '₹';

  // Tax calculation: 18% GST (India)
  const TAX_RATE = 0.18;

  // ── DOM Elements ──
  const form = document.getElementById('paymentForm');
  const bookingIdInput = document.getElementById('bookingId');
  const amountInput = document.getElementById('amount');
  const submitBtn = document.getElementById('submitBtn');
  const alertDiv = document.getElementById('alert');
  const summaryContent = document.getElementById('summaryContent');
  const successContent = document.getElementById('successContent');

  // Summary elements
  const tripCostSpan = document.getElementById('tripCost');
  const taxesSpan = document.getElementById('taxes');
  const totalAmountSpan = document.getElementById('totalAmount');
  const transactionIdSpan = document.getElementById('transactionId');
  const paidAmountSpan = document.getElementById('paidAmount');

  // ── Event Listeners ──
  if (form) {
    amountInput.addEventListener('input', updateSummary);
    bookingIdInput.addEventListener('input', updateSummary);
    form.addEventListener('submit', handlePaymentSubmit);
  }

  /**
   * Update the summary display
   */
  function updateSummary() {
    const amount = parseFloat(amountInput.value) || 0;
    const taxes = amount * TAX_RATE;
    const total = amount + taxes;

    tripCostSpan.textContent = amount.toFixed(2);
    taxesSpan.textContent = taxes.toFixed(2);
    totalAmountSpan.textContent = total.toFixed(2);
  }

  /**
   * Handle form submission
   */
  async function handlePaymentSubmit(event) {
    event.preventDefault();

    // Get form values
    const bookingId = parseInt(bookingIdInput.value, 10);
    const amount = parseFloat(amountInput.value);
    const paymentMethod = document.querySelector('input[name="paymentMethod"]:checked').value;
    const cardName = document.getElementById('cardName').value;
    const email = document.getElementById('email').value;

    // Validation
    if (!bookingId || bookingId <= 0) {
      showAlert('Please enter a valid booking ID', 'error');
      return;
    }

    if (!amount || amount <= 0) {
      showAlert('Please enter a valid amount', 'error');
      return;
    }

    if (!paymentMethod) {
      showAlert('Please select a payment method', 'error');
      return;
    }

    if (!cardName.trim()) {
      showAlert('Please enter cardholder name', 'error');
      return;
    }

    if (!email.trim() || !isValidEmail(email)) {
      showAlert('Please enter a valid email address', 'error');
      return;
    }

    // Disable submit button
    submitBtn.disabled = true;
    submitBtn.innerHTML = '<span class="loading"></span>Processing...';

    try {
      // Call payment API
      const response = await fetch(`${API_BASE}/payments/process`, {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify({
          bookingId: bookingId,
          amount: amount.toFixed(2),
          paymentMethod: paymentMethod
        })
      });

      const data = await response.json();

      if (response.ok && data.success) {
        // Payment successful
        showPaymentSuccess(data);
      } else {
        // Payment failed
        showAlert(data.error || 'Payment processing failed. Please try again.', 'error');
        submitBtn.disabled = false;
        submitBtn.textContent = 'Pay Now';
      }

    } catch (error) {
      console.error('Payment error:', error);
      showAlert('Network error. Please check your connection and try again.', 'error');
      submitBtn.disabled = false;
      submitBtn.textContent = 'Pay Now';
    }
  }

  /**
   * Show payment success message
   */
  function showPaymentSuccess(paymentData) {
    const amount = parseFloat(amountInput.value);

    // Update success content with transaction details
    transactionIdSpan.textContent = paymentData.transactionId;
    paidAmountSpan.textContent = amount.toFixed(2);

    // Hide form, show success message
    summaryContent.style.display = 'none';
    successContent.style.display = 'block';

    // Scroll to success message
    successContent.scrollIntoView({ behavior: 'smooth' });

    // Log success
    console.log('Payment successful:', {
      paymentId: paymentData.paymentId,
      transactionId: paymentData.transactionId,
      status: paymentData.status,
      amount: paymentData.amount
    });

    // Send email notification (in real app)
    sendConfirmationEmail(
      document.getElementById('email').value,
      paymentData.transactionId,
      amount.toFixed(2)
    );
  }

  /**
   * Show alert message
   */
  function showAlert(message, type) {
    alertDiv.textContent = message;
    alertDiv.className = `alert ${type}`;
    alertDiv.style.display = 'block';

    // Auto-hide alert after 5 seconds
    if (type === 'success') {
      setTimeout(() => {
        alertDiv.style.display = 'none';
      }, 5000);
    }

    // Scroll to alert
    alertDiv.scrollIntoView({ behavior: 'smooth' });
  }

  /**
   * Validate email format
   */
  function isValidEmail(email) {
    const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    return emailRegex.test(email);
  }

  /**
   * Simulate sending confirmation email (in real app, call backend)
   */
  function sendConfirmationEmail(email, transactionId, amount) {
    console.log(`Confirmation email sent to ${email}`);
    console.log(`Transaction: ${transactionId}, Amount: ${amount}`);
    
    // In a real application, this would call a backend endpoint
    // to send an actual email via a mail service
  }

  /**
   * Format currency display
   */
  function formatCurrency(value) {
    return `${CURRENCY} ${parseFloat(value).toFixed(2)}`;
  }

  /**
   * Get payment status badge
   */
  function getStatusBadge(status) {
    const badges = {
      'Success': '<span style="color: #10B981; font-weight: 700;">✓ Success</span>',
      'Failed': '<span style="color: #EF4444; font-weight: 700;">✗ Failed</span>',
      'Pending': '<span style="color: #F59E0B; font-weight: 700;">⏳ Pending</span>'
    };
    return badges[status] || status;
  }

  /**
   * Initialize payment page on load
   */
  function initPaymentPage() {
    // Check if booking ID is passed via URL parameter
    const urlParams = new URLSearchParams(window.location.search);
    const bookingIdParam = urlParams.get('bookingId');
    const amountParam = urlParams.get('amount');

    if (bookingIdParam) {
      bookingIdInput.value = bookingIdParam;
    }

    if (amountParam) {
      amountInput.value = amountParam;
      updateSummary();
    }

    // Set default payment method
    document.getElementById('credit').checked = true;
  }

  // Initialize on page load
  if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', initPaymentPage);
  } else {
    initPaymentPage();
  }

})();
