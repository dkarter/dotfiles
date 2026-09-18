export const createRefreshCoordinator = (run: (signal: AbortSignal) => Promise<void>) => {
  let active: AbortController | undefined;
  let disposed = false;
  let pending = false;

  const request = () => {
    if (disposed) {
      return;
    }
    if (active) {
      pending = true;
      return;
    }

    const controller = new AbortController();
    active = controller;
    void run(controller.signal)
      .catch(() => {})
      .finally(() => {
        if (active === controller) {
          active = undefined;
        }
        if (pending && !disposed) {
          pending = false;
          request();
        }
      });
  };

  return {
    request,
    dispose: () => {
      disposed = true;
      pending = false;
      active?.abort();
    },
  };
};
