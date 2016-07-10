package resource;

import java.util.concurrent.atomic.AtomicLong;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.bind.annotation.RequestMethod;

@RestController
@RequestMapping("/location")
public class ResourceController {

    private static final String template = "Hello, %s!";
    private final AtomicLong counter = new AtomicLong();

    @RequestMapping(method = RequestMethod.GET)
    public String location(@RequestParam(value="username", defaultValue="") String username,
                           @RequestParam(value="userid", defaultValue="") String id) {
        SocketRequestGet request = new SocketRequestGet(username, id);
        Thread t =new Thread(request);
        t.start();

        try {
          t.join();
        } catch (InterruptedException ie) {
          ie.printStackTrace();
        }
        return request.getServerResponse();
    }

    @RequestMapping(method = RequestMethod.POST)
    public String location(@RequestParam(value="username", defaultValue="") String username,
                           @RequestParam(value="userid", defaultValue="") String id,
                           @RequestParam(value="longitude", defaultValue="") String longitude,
                           @RequestParam(value="latitude", defaultValue="") String latitude) {

        SocketRequestPost request = new SocketRequestPost(username, id, longitude, latitude);
        Thread t =new Thread(request);
        t.start();

        try {
          t.join();
        } catch (InterruptedException ie) {
          ie.printStackTrace();
        }
        return request.getServerResponse();

    }
}
