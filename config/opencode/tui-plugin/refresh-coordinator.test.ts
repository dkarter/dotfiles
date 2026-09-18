import { describe, expect, test } from 'bun:test';

import { createRefreshCoordinator } from './refresh-coordinator';

const deferred = () => {
  let resolve!: () => void;
  const promise = new Promise<void>((done) => {
    resolve = done;
  });
  return { promise, resolve };
};

const settle = async () => {
  await Promise.resolve();
  await Promise.resolve();
};

describe('createRefreshCoordinator', () => {
  test('coalesces a burst into one active and one trailing refresh', async () => {
    const runs = [deferred(), deferred()];
    const signals: AbortSignal[] = [];
    const coordinator = createRefreshCoordinator((signal) => {
      signals.push(signal);
      return runs[signals.length - 1]!.promise;
    });

    coordinator.request();
    coordinator.request();
    coordinator.request();
    expect(signals).toHaveLength(1);

    runs[0]!.resolve();
    await settle();
    expect(signals).toHaveLength(2);

    runs[1]!.resolve();
    await settle();
  });

  test('aborts the active refresh and drops queued work on disposal', async () => {
    const run = deferred();
    const signals: AbortSignal[] = [];
    const coordinator = createRefreshCoordinator((signal) => {
      signals.push(signal);
      return run.promise;
    });

    coordinator.request();
    coordinator.request();
    coordinator.dispose();
    expect(signals[0]!.aborted).toBe(true);

    run.resolve();
    await settle();
    coordinator.request();
    expect(signals).toHaveLength(1);
  });
});
