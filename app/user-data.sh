#!/bin/bash

set -e

# ============================================================
# CloudCampus Stay - EC2 User Data Script
# This script bootstraps a lightweight web server for the
# CloudCampus Stay high availability project.
# ============================================================

WEB_ROOT="/var/www/html"

mkdir -p "$WEB_ROOT"

# ------------------------------------------------------------
# Get EC2 instance metadata using IMDSv2
# ------------------------------------------------------------

TOKEN=$(curl -s -X PUT "http://169.254.169.254/latest/api/token" \
  -H "X-aws-ec2-metadata-token-ttl-seconds: 21600" || true)

if [ -n "$TOKEN" ]; then
  INSTANCE_ID=$(curl -s -H "X-aws-ec2-metadata-token: $TOKEN" \
    http://169.254.169.254/latest/meta-data/instance-id || echo "unknown")

  AVAILABILITY_ZONE=$(curl -s -H "X-aws-ec2-metadata-token: $TOKEN" \
    http://169.254.169.254/latest/meta-data/placement/availability-zone || echo "unknown")

  PRIVATE_IP=$(curl -s -H "X-aws-ec2-metadata-token: $TOKEN" \
    http://169.254.169.254/latest/meta-data/local-ipv4 || echo "unknown")
else
  INSTANCE_ID="unknown"
  AVAILABILITY_ZONE="unknown"
  PRIVATE_IP="unknown"
fi

# ------------------------------------------------------------
# Create health check endpoint for ALB Target Group
# ------------------------------------------------------------

cat > "$WEB_ROOT/health" <<'EOF'
OK
EOF

# ------------------------------------------------------------
# Create CSS file
# ------------------------------------------------------------

cat > "$WEB_ROOT/style.css" <<'EOF'
* {
  box-sizing: border-box;
  margin: 0;
  padding: 0;
}

html {
  scroll-behavior: smooth;
}

body {
  font-family: Arial, Helvetica, sans-serif;
  color: #1f2937;
  background: #f8fafc;
  line-height: 1.6;
}

a {
  text-decoration: none;
  color: inherit;
}

.container {
  width: min(1120px, 92%);
  margin: 0 auto;
}

.site-header {
  background: #ffffff;
  border-bottom: 1px solid #e5e7eb;
  position: sticky;
  top: 0;
  z-index: 10;
}

.header-content {
  height: 72px;
  display: flex;
  align-items: center;
  justify-content: space-between;
}

.logo {
  font-size: 1.35rem;
  font-weight: 700;
  color: #0f172a;
}

.nav-links {
  display: flex;
  gap: 1.5rem;
}

.nav-links a {
  font-size: 0.95rem;
  color: #475569;
  font-weight: 500;
}

.nav-links a:hover {
  color: #2563eb;
}

.hero {
  background: linear-gradient(135deg, #0f172a 0%, #1e3a8a 55%, #2563eb 100%);
  color: #ffffff;
  padding: 96px 0;
}

.hero-content {
  max-width: 760px;
}

.eyebrow {
  display: inline-block;
  font-size: 0.85rem;
  font-weight: 700;
  letter-spacing: 0.08em;
  text-transform: uppercase;
  color: #bfdbfe;
  margin-bottom: 1rem;
}

.hero h1 {
  font-size: clamp(2.4rem, 5vw, 4.5rem);
  line-height: 1.05;
  margin-bottom: 1.25rem;
}

.hero-text {
  font-size: 1.15rem;
  color: #dbeafe;
  max-width: 680px;
  margin-bottom: 2rem;
}

.hero-actions {
  display: flex;
  gap: 1rem;
  flex-wrap: wrap;
}

.button {
  display: inline-block;
  padding: 0.85rem 1.25rem;
  border-radius: 999px;
  font-weight: 700;
}

.button.primary {
  background: #ffffff;
  color: #1e3a8a;
}

.button.secondary {
  border: 1px solid rgba(255, 255, 255, 0.7);
  color: #ffffff;
}

.section {
  padding: 80px 0;
}

.section h2 {
  font-size: 2rem;
  color: #0f172a;
  margin-bottom: 0.75rem;
}

.section-intro {
  color: #64748b;
  max-width: 640px;
  margin-bottom: 2rem;
}

.room-grid {
  display: grid;
  grid-template-columns: repeat(3, 1fr);
  gap: 1.5rem;
}

.room-card {
  background: #ffffff;
  border: 1px solid #e5e7eb;
  border-radius: 24px;
  padding: 1.5rem;
  box-shadow: 0 16px 32px rgba(15, 23, 42, 0.06);
}

.room-card h3 {
  font-size: 1.25rem;
  color: #0f172a;
  margin-bottom: 0.5rem;
}

.price {
  font-size: 1.1rem;
  font-weight: 700;
  color: #2563eb;
  margin-bottom: 0.75rem;
}

.room-card p {
  color: #475569;
  margin-bottom: 1rem;
}

.room-card ul {
  list-style-position: inside;
  color: #64748b;
}

.booking-section {
  background: #eef2ff;
}

.booking-layout {
  display: grid;
  grid-template-columns: 1fr 1.2fr;
  gap: 2rem;
  align-items: start;
}

.booking-form {
  background: #ffffff;
  border-radius: 24px;
  padding: 1.5rem;
  border: 1px solid #e5e7eb;
  box-shadow: 0 18px 36px rgba(15, 23, 42, 0.08);
}

.booking-form label {
  display: block;
  font-weight: 700;
  color: #334155;
  margin-bottom: 1rem;
}

.booking-form input,
.booking-form select {
  width: 100%;
  margin-top: 0.4rem;
  padding: 0.85rem 1rem;
  border: 1px solid #cbd5e1;
  border-radius: 12px;
  font-size: 1rem;
}

.date-row {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 1rem;
}

.booking-form button {
  width: 100%;
  border: none;
  border-radius: 999px;
  padding: 0.9rem 1.25rem;
  background: #2563eb;
  color: #ffffff;
  font-size: 1rem;
  font-weight: 700;
  cursor: pointer;
  margin-top: 0.5rem;
}

.about-section {
  background: #ffffff;
}

.about-section p {
  max-width: 820px;
  color: #475569;
  font-size: 1.05rem;
}

.site-footer {
  background: #0f172a;
  color: #cbd5e1;
  padding: 32px 0;
}

.server-info {
  font-size: 0.95rem;
  color: #93c5fd;
}

.instance-box {
  margin-top: 1rem;
  background: #111827;
  border: 1px solid #334155;
  border-radius: 16px;
  padding: 1rem;
  color: #dbeafe;
}

.instance-box code {
  color: #93c5fd;
}

@media (max-width: 900px) {
  .room-grid {
    grid-template-columns: 1fr;
  }

  .booking-layout {
    grid-template-columns: 1fr;
  }
}

@media (max-width: 640px) {
  .header-content {
    height: auto;
    padding: 1rem 0;
    flex-direction: column;
    gap: 0.75rem;
  }

  .nav-links {
    gap: 1rem;
  }

  .hero {
    padding: 72px 0;
  }

  .date-row {
    grid-template-columns: 1fr;
  }
}
EOF

# ------------------------------------------------------------
# Create HTML file
# ------------------------------------------------------------

cat > "$WEB_ROOT/index.html" <<'EOF'
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>CloudCampus Stay</title>
  <link rel="stylesheet" href="style.css" />
</head>

<body>
  <header class="site-header">
    <div class="container header-content">
      <div class="logo">CloudCampus Stay</div>
      <nav class="nav-links">
        <a href="#rooms">Rooms</a>
        <a href="#booking">Booking</a>
        <a href="#about">About</a>
      </nav>
    </div>
  </header>

  <main>
    <section class="hero">
      <div class="container hero-content">
        <p class="eyebrow">Campus Visit Hotel Booking</p>
        <h1>Comfortable stays for international students and families visiting campus.</h1>
        <p class="hero-text">
          CloudCampus Stay is a hotel booking prototype designed for orientation,
          move-in, campus tours, family visits, and graduation trips.
        </p>
        <div class="hero-actions">
          <a href="#rooms" class="button primary">View Rooms</a>
          <a href="#booking" class="button secondary">Request Booking</a>
        </div>
      </div>
    </section>

    <section id="rooms" class="section">
      <div class="container">
        <h2>Room Options</h2>
        <p class="section-intro">
          Choose a stay option based on your campus visit purpose.
        </p>

        <div class="room-grid">
          <article class="room-card">
            <h3>Standard Campus Room</h3>
            <p class="price">$99 / night</p>
            <p>Ideal for short campus visits and orientation trips.</p>
            <ul>
              <li>Queen bed</li>
              <li>Free Wi-Fi</li>
              <li>Campus shuttle nearby</li>
            </ul>
          </article>

          <article class="room-card">
            <h3>Family Visit Suite</h3>
            <p class="price">$149 / night</p>
            <p>Designed for parents and family members visiting students.</p>
            <ul>
              <li>Two beds</li>
              <li>Breakfast included</li>
              <li>Extra luggage space</li>
            </ul>
          </article>

          <article class="room-card">
            <h3>Graduation Weekend Suite</h3>
            <p class="price">$229 / night</p>
            <p>A premium stay option for graduation and special campus events.</p>
            <ul>
              <li>King bed</li>
              <li>Lounge area</li>
              <li>Premium campus view</li>
            </ul>
          </article>
        </div>
      </div>
    </section>

    <section id="booking" class="section booking-section">
      <div class="container booking-layout">
        <div>
          <h2>Request a Booking</h2>
          <p class="section-intro">
            This form is a frontend prototype. Database integration will be added in a future version.
          </p>
        </div>

        <form class="booking-form">
          <label>
            Guest Name
            <input type="text" placeholder="Your name" />
          </label>

          <label>
            Email
            <input type="email" placeholder="you@example.com" />
          </label>

          <label>
            Visit Purpose
            <select>
              <option>Orientation</option>
              <option>Move-in</option>
              <option>Campus Tour</option>
              <option>Graduation</option>
              <option>Family Visit</option>
              <option>Other</option>
            </select>
          </label>

          <label>
            Room Type
            <select>
              <option>Standard Campus Room</option>
              <option>Family Visit Suite</option>
              <option>Graduation Weekend Suite</option>
            </select>
          </label>

          <div class="date-row">
            <label>
              Check-in
              <input type="date" />
            </label>

            <label>
              Check-out
              <input type="date" />
            </label>
          </div>

          <button type="button">Submit Request</button>
        </form>
      </div>
    </section>

    <section id="about" class="section about-section">
      <div class="container">
        <h2>About This AWS Project</h2>
        <p>
          This project demonstrates a highly available web application architecture on AWS.
          The application runs behind an Application Load Balancer, while EC2 instances are
          managed by an Auto Scaling Group across multiple Availability Zones.
        </p>
      </div>
    </section>
  </main>

  <footer class="site-footer">
    <div class="container">
      <p>CloudCampus Stay | AWS Highly Available Web App Project</p>

      <div class="instance-box">
        <p><strong>Served by EC2 instance:</strong> <code>__INSTANCE_ID__</code></p>
        <p><strong>Availability Zone:</strong> <code>__AVAILABILITY_ZONE__</code></p>
        <p><strong>Private IP:</strong> <code>__PRIVATE_IP__</code></p>
      </div>
    </div>
  </footer>
</body>
</html>
EOF

# ------------------------------------------------------------
# Replace placeholders with actual EC2 metadata
# ------------------------------------------------------------

sed -i "s|__INSTANCE_ID__|$INSTANCE_ID|g" "$WEB_ROOT/index.html"
sed -i "s|__AVAILABILITY_ZONE__|$AVAILABILITY_ZONE|g" "$WEB_ROOT/index.html"
sed -i "s|__PRIVATE_IP__|$PRIVATE_IP|g" "$WEB_ROOT/index.html"

# ------------------------------------------------------------
# Create systemd service for lightweight Python web server
# ------------------------------------------------------------

cat > /etc/systemd/system/cloudcampus-web.service <<'EOF'
[Unit]
Description=CloudCampus Stay Web Server
After=network.target

[Service]
Type=simple
WorkingDirectory=/var/www/html
ExecStart=/usr/bin/python3 -m http.server 80 --bind 0.0.0.0
Restart=always
RestartSec=5

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl enable cloudcampus-web.service
systemctl start cloudcampus-web.service

# ------------------------------------------------------------
# Basic local validation
# ------------------------------------------------------------

curl -s http://localhost/health > /tmp/cloudcampus-health-check.txt || true
echo "CloudCampus Stay user data completed successfully." > /tmp/cloudcampus-user-data-status.txt