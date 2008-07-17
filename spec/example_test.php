<?php
require_once dirname(__FILE__).'/../test_helper.php';

class PublisherIntegrationTest extends PHPUnit_Framework_TestCase
{
    public function setUp() 
    {
    }
    
    public function testGetPublishers()
    {
        $publishers = $this->gnip->getPublishers();
        assertContains($this->publisher, $publishers);
    }

    public function testGetPublisher()
    {
        $this->assertEquals($this->gnip->getPublisher("bob"), $this->publisher);
    }

    public function testPublishActivities()
    {
        // DATE_ISO8601 gives us 2008-07-15T15:42:47-0700
        // DATE_ATOM    gives us 2008-07-15T15:43:46-07:00 
        $atString = date_create()->format(DATE_ATOM);

        $activity = new Services_Gnip_Activity($atString,'added_friend','foo/bob1');
        $this->gnip->publish($this->publisher, array($activity));

        $activities = $this->gnip->getActivities($this->publisher);
        assertContains($activity, $activities);
    }
}
?>