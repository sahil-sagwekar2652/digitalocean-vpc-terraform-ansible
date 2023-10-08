echo "Press Ctrl+C to exit the loop\n"
ip=$(cat ansible/output.json | jq '.loadbalancer_ip.value' | tr -d '"')

for i in {1..10}; do curl $ip; done

