-- Add alert_active column to incidents table
-- This column tracks whether alert notifications are active for an incident

ALTER TABLE incidents 
ADD COLUMN alert_active boolean NOT NULL DEFAULT true;

-- Add comment for documentation
COMMENT ON COLUMN incidents.alert_active IS 'Indicates whether alert notifications are active for this incident';
