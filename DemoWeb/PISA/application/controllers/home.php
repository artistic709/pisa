<?php
class home extends CI_Controller
{
	public function index()
	{
		$this->load->library('session');
		$this->load->helper('url');
		$this->load->helper('form');
		$this->load->helper('string');

		$this->load->view('home.php');
	}
}
?>