import ceylon.test { ... }
import ceylon.test.core {
	DefaultLoggingListener
}
	
shared void run() {
	createTestRunner([`module test.org.omadac.graph`], [DefaultLoggingListener()]).run();
}    
