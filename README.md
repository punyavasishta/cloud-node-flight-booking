# Cloud Node — Flight Booking

Same **Cloud Node** theme (green / cream / gold). Booking works like a full multi-step flow, backed by MySQL via `FlightServer`.

## Booking procedure (like the rich demo flow)

1. **Search** — From / To / optional date (only flights with open seats).
2. **Passenger** — Choose a registered passenger (add under **Passengers** if needed).
3. **Seat map** — Cabin grid; taken seats disabled (`GET /api/seats`); legroom rows highlighted.
4. **Meals** — Optional complimentary meal choice (saved as special request).
5. **Contact & payment** — Name / email / phone + UPI / Card / NetBanking / Wallet (demo; no real charge).
6. **Confirm** — Writes `Bookings`. If you ran `flight_booking_extensions.sql`, also writes `BookingDetails` + `Payments`.
7. **Done** — Boarding-pass style card with **PNR** (e.g. `CN000021`).

Theme, intro curtains, destinations, dashboard tables — **unchanged**.

## Setup

1. MySQL — create schema and sample data:

```bash
mysql -u root -p < flight_booking.sql
mysql -u root -p < flight_booking_extensions.sql   # recommended (Payments, BookingDetails, daily flights)
```

2. Password — edit `PASS` in `FlightServer.java`, or:

```bash
export DB_PASS='your_password'
```

3. Run:

```bash
chmod +x run.sh
./run.sh
```

4. Open **http://localhost:8080**

## API

| Endpoint | Purpose |
|----------|---------|
| `GET /api/flights` | All flights + availability |
| `GET /api/seats?flightId=N` | Taken seat numbers for the map |
| `GET /api/passengers` | Registered passengers |
| `POST /api/passengers/add` | Add passenger |
| `POST /api/book` | Book with passenger, flight, seat + optional contact / payment / specialRequests → bookingId + pnr |
| `POST /api/cancel` | Cancel booking |
| `GET /api/bookings` | Full booking list |
| `GET /api/unbooked-flights` | Flights with no bookings |
| `GET /api/top-flights` | Top 3 by bookings |
| `GET /api/airline-counts` | Flights per airline |

## Files

- index.html — frontend (Cloud Node theme + rich booking)
- FlightServer.java — HTTP + JDBC API
- mysql-connector-j-26.7.0.jar — MySQL driver
- flight_booking.sql — base schema + seed
- flight_booking_extensions.sql — schedules, daily instances, Payments, BookingDetails
- run.sh — compile & start
