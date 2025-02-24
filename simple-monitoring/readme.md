## Netdata

### Install netdata
Run `setup.sh` script.

### Setup an alert for a specific metric
Copy `custom_cpu_usage.conf` to `/etc/netdata/health.d/` directory

### Test custom alert
Run `test_dashboard.sh` script to generate some stress.

### View custom alert 
Open netdata dashboard at `http://\<your-server-ip\>:19999/`

### Cleanup environment
Run `cleanup.sh` script.
