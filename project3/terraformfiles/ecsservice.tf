resource "aws_ecs_service" "service1" {
    name = "test-http"
    cluster = "${aws_ecs_cluster.zephyrecscluster.id}"
    task_definition = "${aws_ecs_task_definition.task1.arn}"
    iam_role = "${aws_iam_role.ecs_instance_role.arn}"
    desired_count = 1
    depends_on = ["aws_iam_role_policy.ecs_service_role_policy"]

    load_balancer {
    target_group_arn = "${aws_alb_target_group.zephyralbtg.arn}"
    container_name   = "zephyrdocker"
    container_port   = "80"
  }
}