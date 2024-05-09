import http from 'k6/http';
import { sleep } from 'k6';
export const options = {
  vus: 20,
  duration: '1200s',
};

//To load test
//Replace ingress-url with actual value after ingress resource creates a LB
export default function () {
  http.get('<ingress_hostname_to_access_echo_server>');
  sleep(1);
}
