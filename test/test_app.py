from app.main import healthz

def test_healthz_returns_ok():
    assert healthz() == {"status": "ok"}