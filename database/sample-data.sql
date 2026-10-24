-- Sample data for BloodBridge
USE bloodbridge;

-- Users
INSERT INTO users (username, password_hash, email, role) VALUES
('admin', SHA2('adminpass',256), 'admin@bloodbridge.com', 'ADMIN'),
('staff1', SHA2('staffpass',256), 'staff1@bloodbridge.com', 'STAFF'),
('donor1', SHA2('donorpass',256), 'donor1@example.com', 'DONOR');

-- Organizations (hospitals & blood banks)
INSERT INTO organizations (name, type, address, city, state, zip) VALUES
('City General Hospital', 'HOSPITAL', '123 Main St', 'Metropolis', 'StateX', '12345'),
('Northside Medical Centre', 'HOSPITAL', '456 North Rd', 'Metropolis', 'StateX', '12346'),
('Hope Blood Centre', 'BLOODBANK', '789 Blood Ave', 'Metropolis', 'StateX', '12347'),
('LifeSource Blood Bank', 'BLOODBANK', '321 Life St', 'Metropolis', 'StateX', '12348');

-- Inventory for blood banks (example units)
INSERT INTO blood_inventory (org_id, blood_group, units) VALUES
((SELECT org_id FROM organizations WHERE name='Hope Blood Centre'), 'O-', 12),
((SELECT org_id FROM organizations WHERE name='Hope Blood Centre'), 'O+', 48),
((SELECT org_id FROM organizations WHERE name='LifeSource Blood Bank'), 'A-', 19),
((SELECT org_id FROM organizations WHERE name='LifeSource Blood Bank'), 'A+', 36),
((SELECT org_id FROM organizations WHERE name='Hope Blood Centre'), 'B-', 14),
((SELECT org_id FROM organizations WHERE name='Hope Blood Centre'), 'B+', 27),
((SELECT org_id FROM organizations WHERE name='LifeSource Blood Bank'), 'AB-', 8),
((SELECT org_id FROM organizations WHERE name='Hope Blood Centre'), 'AB+', 22);

-- Blood requests from hospitals
INSERT INTO blood_requests (requesting_org_id, blood_group, units_needed, priority, status) VALUES
((SELECT org_id FROM organizations WHERE name='City General Hospital'), 'O-', 3, 'URGENT', 'PENDING'),
((SELECT org_id FROM organizations WHERE name='Northside Medical Centre'), 'AB+', 2, 'HIGH', 'PENDING'),
((SELECT org_id FROM organizations WHERE name='City General Hospital'), 'A+', 5, 'STANDARD', 'PENDING');

-- Example allocation (partial allocation for first request)
INSERT INTO allocations (request_id, inventory_id, units_allocated) VALUES
((SELECT request_id FROM blood_requests WHERE requesting_org_id=(SELECT org_id FROM organizations WHERE name='City General Hospital') LIMIT 1),
 (SELECT inventory_id FROM blood_inventory WHERE org_id=(SELECT org_id FROM organizations WHERE name='Hope Blood Centre') AND blood_group='O-' LIMIT 1), 2);

-- Request status history
INSERT INTO request_status_history (request_id, previous_status, new_status, changed_by) VALUES
((SELECT request_id FROM blood_requests WHERE requesting_org_id=(SELECT org_id FROM organizations WHERE name='City General Hospital') LIMIT 1), 'PENDING', 'PARTIAL', (SELECT user_id FROM users WHERE username='staff1'));

-- Notifications (example)
INSERT INTO notifications (recipient_org_id, message) VALUES
((SELECT org_id FROM organizations WHERE name='City General Hospital'), 'Your urgent O- request has been partially fulfilled.');

-- Audit logs (example)
INSERT INTO audit_logs (user_id, action, details, ip_address) VALUES
((SELECT user_id FROM users WHERE username='admin'), 'CREATE_USER', 'Created admin user', '127.0.0.1');
