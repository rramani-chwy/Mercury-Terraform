 ```bash
 ./deploy-v1.sh qa image_tag
 ```

# What needs to be defined by app team:
	container_port
	service_autoscale_max
	service_autoscale_min
	service_autoscale_alarm
	service_autoscale_namespace
	service_autoscale_dimensions
	service_autoscale_statistic
	service_autoscale_y_axis_unit
	service_autoscale_low_threshold
	service_autoscale_high_threshold
	service_autoscale_increment_count
	service_autoscale_decrement_count


# In the shell script:
	auto generate 'taskdef_var.json'
	complete 'deploy_cfg.json'
