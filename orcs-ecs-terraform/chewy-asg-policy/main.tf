resource "aws_autoscaling_policy" "policy" {
    name = "${var.policy_name}"
    scaling_adjustment = "${var.scaling_adjustment}"
    adjustment_type = "${var.adjustment_type}"
    cooldown = "${var.cooldown}"
    autoscaling_group_name = "${var.asg_name}"
}

resource "aws_cloudwatch_metric_alarm" "alarm" {
    alarm_name = "${var.alarm_name}"
    comparison_operator = "${var.comparison_operator}"
    evaluation_periods = "${var.eval_periods}"
    metric_name = "${var.metric_name}"
    namespace = "${var.namespace}"
    period = "${var.period}"
    statistic = "${var.statistic}"
    threshold = "${var.threshold}"
    alarm_description = "${var.description}"
    alarm_actions = [
        "${aws_autoscaling_policy.policy.arn}"
    ]
    dimensions {
        ClusterName = "${var.cluster_name}"
    }
    lifecycle {
        ignore_changes = ["datapoints_to_alarm"]
    }
    
}
