package com.funcom.ccg.util;

import java.io.ByteArrayOutputStream;

import org.apache.thrift.TBase;
import org.apache.thrift.TException;
import org.apache.thrift.protocol.TBinaryProtocol;
import org.apache.thrift.protocol.TJSONProtocol;
import org.apache.thrift.protocol.TProtocol;
import org.apache.thrift.protocol.TProtocolFactory;
import org.apache.thrift.transport.TIOStreamTransport;
import org.apache.thrift.transport.TMemoryInputTransport;
import org.apache.thrift.transport.TTransport;

public final class ThriftUtils {

	public static final String APPLICATION_THRIFT_VALUE = "application/x-thrift";
	public static final TProtocolFactory BINARY_PROTOCOL_FACTORY = new TBinaryProtocol.Factory();
	public static final TProtocolFactory JSON_PROTOCOL_FACTORY = new TJSONProtocol.Factory();

	public static void deserialize(TProtocolFactory factory, TBase<?, ?> base, byte[] raw) {
		final TTransport transport = new TMemoryInputTransport(raw);
		final TProtocol protocol = factory.getProtocol(transport);

		try {
			base.read(protocol);
		}
		catch (TException e) {
			throw new RuntimeException("Could not deserialize object from thrift!", e);
		}
	}

	public static byte[] serialize(TProtocolFactory factory, TBase<?, ?> base) {
		final ByteArrayOutputStream buffer = new ByteArrayOutputStream(0);
		final TTransport transport = new TIOStreamTransport(buffer);
		final TProtocol protocol = factory.getProtocol(transport);

		try {
			base.write(protocol);
		}
		catch (TException e) {
			throw new RuntimeException("Could not serialize object to thrift!", e);
		}

		return buffer.toByteArray();
	}

	public static void fromBinary(TBase<?, ?> base, byte[] raw) {
		deserialize(BINARY_PROTOCOL_FACTORY, base, raw);
	}

	public static byte[] toBinary(TBase<?, ?> base) {
		return serialize(BINARY_PROTOCOL_FACTORY, base);
	}

}
