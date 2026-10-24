-- BloodBridge Database Schema
CREATE DATABASE IF NOT EXISTS bloodbridge;
USE bloodbridge;

-- Users table
CREATE TABLE users (
    user_id BIGINT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    role ENUM('ADMIN','STAFF','DONOR') NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB;

-- Organizations (hospitals, blood banks, etc.)
CREATE TABLE organizations (
    org_id BIGINT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(150) NOT NULL,
    type ENUM('HOSPITAL','BLOODBANK') NOT NULL,
    address VARCHAR(255),
    city VARCHAR(100),
    state VARCHAR(100),
    zip VARCHAR(20),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB;

-- Blood inventory per organization
CREATE TABLE blood_inventory (
    inventory_id BIGINT AUTO_INCREMENT PRIMARY KEY,
    org_id BIGINT NOT NULL,
    blood_group ENUM('O-','O+','A-','A+','B-','B+','AB-','AB+') NOT NULL,
    units INT NOT NULL CHECK (units >= 0),
    last_updated TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (org_id) REFERENCES organizations(org_id) ON DELETE CASCADE
) ENGINE=InnoDB;

-- Blood requests from hospitals
CREATE TABLE blood_requests (
    request_id BIGINT AUTO_INCREMENT PRIMARY KEY,
    requesting_org_id BIGINT NOT NULL,
    blood_group ENUM('O-','O+','A-','A+','B-','B+','AB-','AB+') NOT NULL,
    units_needed INT NOT NULL CHECK (units_needed > 0),
    priority ENUM('URGENT','HIGH','STANDARD') NOT NULL,
    status ENUM('PENDING','PARTIAL','FULFILLED','CANCELLED') NOT NULL DEFAULT 'PENDING',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (requesting_org_id) REFERENCES organizations(org_id) ON DELETE RESTRICT
) ENGINE=InnoDB;

-- Allocation of inventory to requests
CREATE TABLE allocations (
    allocation_id BIGINT AUTO_INCREMENT PRIMARY KEY,
    request_id BIGINT NOT NULL,
    inventory_id BIGINT NOT NULL,
    units_allocated INT NOT NULL CHECK (units_allocated > 0),
    allocated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (request_id) REFERENCES blood_requests(request_id) ON DELETE CASCADE,
    FOREIGN KEY (inventory_id) REFERENCES blood_inventory(inventory_id) ON DELETE RESTRICT
) ENGINE=InnoDB;

-- History of status changes for requests
CREATE TABLE request_status_history (
    history_id BIGINT AUTO_INCREMENT PRIMARY KEY,
    request_id BIGINT NOT NULL,
    previous_status ENUM('PENDING','PARTIAL','FULFILLED','CANCELLED'),
    new_status ENUM('PENDING','PARTIAL','FULFILLED','CANCELLED'),
    changed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    changed_by BIGINT,
    FOREIGN KEY (request_id) REFERENCES blood_requests(request_id) ON DELETE CASCADE,
    FOREIGN KEY (changed_by) REFERENCES users(user_id) ON DELETE SET NULL
) ENGINE=InnoDB;

-- Notifications for users/organizations
CREATE TABLE notifications (
    notification_id BIGINT AUTO_INCREMENT PRIMARY KEY,
    recipient_user_id BIGINT,
    recipient_org_id BIGINT,
    message TEXT NOT NULL,
    is_read BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (recipient_user_id) REFERENCES users(user_id) ON DELETE CASCADE,
    FOREIGN KEY (recipient_org_id) REFERENCES organizations(org_id) ON DELETE CASCADE
) ENGINE=InnoDB;

-- Audit log for critical actions
CREATE TABLE audit_logs (
    audit_id BIGINT AUTO_INCREMENT PRIMARY KEY,
    user_id BIGINT,
    action VARCHAR(255) NOT NULL,
    details TEXT,
    ip_address VARCHAR(45),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE SET NULL
) ENGINE=InnoDB;

-- Indexes for performance
CREATE INDEX idx_inventory_org ON blood_inventory(org_id);
CREATE INDEX idx_requests_org ON blood_requests(requesting_org_id);
CREATE INDEX idx_allocations_req ON allocations(request_id);
CREATE INDEX idx_notifications_user ON notifications(recipient_user_id);
CREATE INDEX idx_notifications_org ON notifications(recipient_org_id);
