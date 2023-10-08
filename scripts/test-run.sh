echo "Press Ctrl+C to exit the loop\n"

for i in {1..10}; do curl $(cat ../ansible/output.json | jq '.loadbalancer_ip.value'); done

