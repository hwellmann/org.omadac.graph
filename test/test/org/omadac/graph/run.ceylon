import ceylon.test { ... }
	
shared void run() {
	createTestRunner([`module test.org.omadac.graph`], [SimpleLoggingListener()]).run();
}    
